(function() {
  var expect;

  chai.should();

  describe("Converter", function() {
    it("converts multilines to one line", function() {
      var converter, expected, source;
      source = "first_line;\nsecond_line\nthird_line";
      expected = "first_line;\nsecond_line third_line";
      converter = new Converter(source);
      return converter.multilines_to_one_line().s.should.equal(expected);
    });
    it("converts multilines to one line with args", function() {
      var converter, expected, source;
      source = "UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@\"Warning\"\n                                                 message:@\"too many alerts\"\n                                                delegate:nil";
      expected = 'UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"too many alerts" delegate:nil';
      converter = new Converter(source);
      return converter.multilines_to_one_line().s.should.equal(expected);
    });
    it("converts multilines to one line for blank line", function() {
      var converter, expected, source;
      source = "first_line;\n\nsecond_line";
      expected = "first_line;\n\nsecond_line";
      converter = new Converter(source);
      return converter.multilines_to_one_line().s.should.equal(expected);
    });
    it("replaces NSString", function() {
      var converter, expected, source;
      source = 'NSDictionary *updatedLatte = [responseObject objectForKey:@"latte"];';
      expected = 'NSDictionary *updatedLatte = [responseObject objectForKey:"latte"];';
      converter = new Converter(source);
      return converter.replace_nsstring().s.should.equal(expected);
    });
    it("converts square brackets", function() {
      var converter, expected, source;
      source = '[self notifyCreated];';
      expected = 'self.notifyCreated;';
      converter = new Converter(source);
      return converter.convert_square_brackets_expression().s.should.equal(expected);
    });
    it('converts square brackets with args', function() {
      var converter, expected, source;
      source = '[self updateFromJSON:updatedLatte];';
      expected = 'self.updateFromJSON(updatedLatte);';
      converter = new Converter(source);
      return converter.convert_square_brackets_expression().s.should.equal(expected);
    });
    it('converts square brackets with multiple args', function() {
      var converter, expected, source;
      source = '[[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0] autorelease];';
      expected = 'UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemBookmarks,tag:0).autorelease;';
      converter = new Converter(source);
      return converter.convert_square_brackets_expression().s.should.equal(expected);
    });
    it("removes semicolons at end of lines", function() {
      var converter, expected, source;
      source = '[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];';
      expected = '[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]';
      converter = new Converter(source);
      return converter.remove_semicolon_at_the_end().s.should.equal(expected);
    });
    it("removes autorelease", function() {
      var converter, expected, source;
      source = '[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]';
      expected = 'UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)';
      converter = new Converter(source);
      converter.convert_square_brackets_expression();
      return converter.remove_autorelease().s.should.equal(expected);
    });
    it("removes type declarations", function() {
      var converter, expected, source;
      source = 'UIWindow* aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]';
      expected = 'aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]';
      converter = new Converter(source);
      return converter.remove_type_declaration().s.should.equal(expected);
    });
    it("removes type declarations with spaces", function() {
      var converter, expected, source;
      source = '    UIWindow* aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]';
      expected = '    aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]';
      converter = new Converter(source);
      return converter.remove_type_declaration().s.should.equal(expected);
    });
    it("removes multiple type declarations", function() {
      var converter, expected, source;
      source = "UIWindow* aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];\nUIWindow* bWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]";
      expected = "aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];\nbWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]";
      converter = new Converter(source);
      return converter.remove_type_declaration().s.should.equal(expected);
    });
    return it('converts multiline expression', function() {
      var converter, expected, source;
      source = "UIAlertView* alertA = [[[UIAlertView alloc] initWithTitle:@\"Warning\"\n                                                 message:@\"too many alerts\"\n                                                delegate:nil\n                                       cancelButtonTitle:@\"OK\"\n                                       otherButtonTitles:nil] autorelease];\nUIAlertView* alertB = [[[UIAlertView alloc] initWithTitle:@\"Warning\"\n                                                 message:@\"too many alerts\"\n                                                delegate:nil\n                                       cancelButtonTitle:@\"OK\"\n                                       otherButtonTitles:nil] autorelease];\n[alert show];";
      expected = "alertA = UIAlertView.alloc.initWithTitle(\"Warning\",message:\"too many alerts\",delegate:nil,cancelButtonTitle:\"OK\",otherButtonTitles:nil)\nalertB = UIAlertView.alloc.initWithTitle(\"Warning\",message:\"too many alerts\",delegate:nil,cancelButtonTitle:\"OK\",otherButtonTitles:nil)\nalert.show";
      converter = new Converter(source);
      return converter.result().should.equal(expected);
    });
  });

  expect = chai.expect;

  describe("Sanity", function() {
    return it("1 should == 1", function() {
      return expect(1).to.equal(1);
    });
  });

}).call(this);
