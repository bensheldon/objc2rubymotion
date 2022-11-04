---
---
class Converter
  constructor: (string) ->
    @orig = string
    @s = string


  result: ->
    @multilines_to_one_line()
    @replace_nsstring()
    @mark_spaces_in_string()
    @convert_square_brackets_expression()
    @remove_semicolon_at_the_end()
    @remove_autorelease()
    @remove_type_declaration()
    @restore_spaces_in_string()

    #allow idempotency
    result = @s
    @s = @orig

    return result

# HELPERS

  convert_args: (match, groups...) =>
# Consider args with colon followed by spaces
    following_args = groups[1].replace /([^:]+)(\s+)(\S+):/g, '$1,$3:'

    # Clear extra spaces after colons
    following_args = following_args.replace /:\s+/g, ':'

    return "#{groups[0]}(#{following_args})"

  ruby_style_code: (match, groups...) =>
    arg_pattern = /([^:]+)\:\s*(.+)/

    msg = groups[1].replace(arg_pattern, @convert_args)
    return "#{groups[0]}.#{msg}"

  space_to_mark: (match, groups...) =>
    return groups[0].replace /\s/g, '__SPACE__'

# CONVERSIONS

  multilines_to_one_line: ->
# Remove trailing white space first. Refs: TrimTrailingWhiteSpace
    @s = @s.replace /[\t ]+$/, ''
    @s = @s.replace /([^;\s])$\n\s*/mg, '$1 '

    return this

  replace_nsstring: ->
    @s = @s.replace /@("(?:[^\\"]|\\.)*")/g, '$1'

    return this

  mark_spaces_in_string: ->
    @s = @s.replace /("(?:[^\\"]|\\.)*")/g, @space_to_mark

    return this

  restore_spaces_in_string: ->
    @s = @s.replace /__SPACE__/g, ' '

    return this


  convert_square_brackets_expression: ->
    max_attempt = 10 # Avoid infinite loops
    attempt_count = 0
    square_pattern = /\[([^\[\]]+?)\s+([^\[\]]+?)\]/g

    loop
      attempt_count += 1
      if attempt_count > max_attempt
        break
      else if square_pattern.test @s
        @s = @s.replace(square_pattern, @ruby_style_code)
      else
        break

    return this

  remove_semicolon_at_the_end: ->
    @s = @s.replace /;/g, ''

    return this

  remove_autorelease: ->
    @s = @s.replace /\.autorelease/g, ''

    return this

  remove_type_declaration: ->
    @s = @s.replace /([^\s\S]*)[a-zA-Z_0-9]+\s*\*\s*([^=]+)=/gm, '$1$2='

    return this

@Converter = Converter

$().ready ->
  objc = $('.objc textarea')
  rubymotion = $('.rubymotion pre')

  if objc.length and rubymotion.length
    convert = ()->
      converter = new Converter objc.val()
      rubymotion.html converter.result()

    convert()

    $('.objc textarea').bind 'input propertychange', ->
      convert()
