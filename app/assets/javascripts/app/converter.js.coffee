class Converter
  constructor: (string) ->
    @s = string

  convert_args: (match, groups...) =>
    # Consider args with colon followed by spaces
    following_args = groups[1].replace /([^:]+)(\s+)(\S+):/, '$1,$3:'

    # Clear extra spaces after colons
    following_args = following_args.replace /:\s+/, ':'

    return "#{groups[0]}(#{following_args})"

  ruby_style_code: (match, groups...) =>
    arg_pattern = /([^:]+)\:\s*(.+)/

    msg = groups[1].replace(arg_pattern, @convert_args)
    return "#{groups[0]}.#{msg}"

  convert_square_brackets_expression: () ->
    max_attempt = 10 # Avoid infinite loops
    attempt_count = 0
    square_pattern = /\[([^\[\]]+?)\s+([^\[\]]+?)\]/

    loop
      attempt_count += 1
      if attempt_count > max_attempt
        break
      else if square_pattern.test @s
        @s = @s.replace(square_pattern, @ruby_style_code)
      else
        break

    this


@Converter = Converter
