(function() {
  var Converter,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  Converter = (function() {
    function Converter(string) {
      this.space_to_mark = bind(this.space_to_mark, this);
      this.ruby_style_code = bind(this.ruby_style_code, this);
      this.convert_args = bind(this.convert_args, this);
      this.orig = string;
      this.s = string;
    }

    Converter.prototype.result = function() {
      var result;
      this.multilines_to_one_line();
      this.replace_nsstring();
      this.mark_spaces_in_string();
      this.convert_square_brackets_expression();
      this.remove_semicolon_at_the_end();
      this.remove_autorelease();
      this.remove_type_declaration();
      this.restore_spaces_in_string();
      result = this.s;
      this.s = this.orig;
      return result;
    };

    Converter.prototype.convert_args = function() {
      var following_args, groups, match;
      match = arguments[0], groups = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      following_args = groups[1].replace(/([^:]+)(\s+)(\S+):/g, '$1,$3:');
      following_args = following_args.replace(/:\s+/g, ':');
      return groups[0] + "(" + following_args + ")";
    };

    Converter.prototype.ruby_style_code = function() {
      var arg_pattern, groups, match, msg;
      match = arguments[0], groups = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      arg_pattern = /([^:]+)\:\s*(.+)/;
      msg = groups[1].replace(arg_pattern, this.convert_args);
      return groups[0] + "." + msg;
    };

    Converter.prototype.space_to_mark = function() {
      var groups, match;
      match = arguments[0], groups = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return groups[0].replace(/\s/g, '__SPACE__');
    };

    Converter.prototype.multilines_to_one_line = function() {
      this.s = this.s.replace(/[\t ]+$/, '');
      this.s = this.s.replace(/([^;\s])$\n\s*/mg, '$1 ');
      return this;
    };

    Converter.prototype.replace_nsstring = function() {
      this.s = this.s.replace(/@("(?:[^\\"]|\\.)*")/g, '$1');
      return this;
    };

    Converter.prototype.mark_spaces_in_string = function() {
      this.s = this.s.replace(/("(?:[^\\"]|\\.)*")/g, this.space_to_mark);
      return this;
    };

    Converter.prototype.restore_spaces_in_string = function() {
      this.s = this.s.replace(/__SPACE__/g, ' ');
      return this;
    };

    Converter.prototype.convert_square_brackets_expression = function() {
      var attempt_count, max_attempt, square_pattern;
      max_attempt = 10;
      attempt_count = 0;
      square_pattern = /\[([^\[\]]+?)\s+([^\[\]]+?)\]/g;
      while (true) {
        attempt_count += 1;
        if (attempt_count > max_attempt) {
          break;
        } else if (square_pattern.test(this.s)) {
          this.s = this.s.replace(square_pattern, this.ruby_style_code);
        } else {
          break;
        }
      }
      return this;
    };

    Converter.prototype.remove_semicolon_at_the_end = function() {
      this.s = this.s.replace(/;/g, '');
      return this;
    };

    Converter.prototype.remove_autorelease = function() {
      this.s = this.s.replace(/\.autorelease/g, '');
      return this;
    };

    Converter.prototype.remove_type_declaration = function() {
      this.s = this.s.replace(/([^\s\S]*)[a-zA-Z_0-9]+\s*\*\s*([^=]+)=/gm, '$1$2=');
      return this;
    };

    return Converter;

  })();

  this.Converter = Converter;

  $().ready(function() {
    var convert, objc, rubymotion;
    objc = $('.objc textarea');
    rubymotion = $('.rubymotion pre');
    if (objc.length && rubymotion.length) {
      convert = function() {
        var converter;
        converter = new Converter(objc.val());
        return rubymotion.html(converter.result());
      };
      convert();
      return $('.objc textarea').bind('input propertychange', function() {
        return convert();
      });
    }
  });

}).call(this);
