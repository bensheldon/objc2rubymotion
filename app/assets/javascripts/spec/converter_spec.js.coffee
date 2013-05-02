chai.should()

describe "Converter", ->

  it "converts multilines to one line", ->
    source   =  """
                first_line;
                second_line
                third_line
                """
    expected = """
               first_line;
               second_line third_line
               """

    converter = new Converter source
    converter.multilines_to_one_line().s.should.equal expected

  it "converts multilines to one line with args", ->
    source   =  """
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                 message:@"too many alerts"
                                                                delegate:nil
                """
    expected = 'UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"too many alerts" delegate:nil'

    converter = new Converter source
    converter.multilines_to_one_line().s.should.equal expected

  it "converts multilines to one line for blank line", ->
    source   =  """
                first_line;

                second_line
                """
    expected =  """
                first_line;

                second_line
                """

    converter = new Converter source
    converter.multilines_to_one_line().s.should.equal expected


  it "replaces NSString", ->
    source   = 'NSDictionary *updatedLatte = [responseObject objectForKey:@"latte"];'
    expected = 'NSDictionary *updatedLatte = [responseObject objectForKey:"latte"];'

    converter = new Converter source
    converter.replace_nsstring().s.should.equal expected

  it "converts square brackets", ->
    source   = '[self notifyCreated];'
    expected = 'self.notifyCreated;'

    converter = new Converter source
    converter.convert_square_brackets_expression().s.should.equal expected

  it 'converts square brackets with args', ->
    source   = '[self updateFromJSON:updatedLatte];'
    expected = 'self.updateFromJSON(updatedLatte);'

    converter = new Converter source
    converter.convert_square_brackets_expression().s.should.equal expected

  it 'converts square brackets with multiple args', ->
    source   = '[[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0] autorelease];'
    expected = 'UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemBookmarks,tag:0).autorelease;'

    converter = new Converter source
    converter.convert_square_brackets_expression().s.should.equal expected

  it  "removes semicolons at end of lines", ->
    source   = '[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];'
    expected = '[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]'

    converter = new Converter source
    converter.remove_semicolon_at_the_end().s.should.equal expected

  it "removes autorelease", ->
    source   = '[[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]'
    expected = 'UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)'

    converter = new Converter source
    converter.convert_square_brackets_expression()
    converter.remove_autorelease().s.should.equal expected

  it "removes type declarations", ->
    source   = 'UIWindow* aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]'
    expected = 'aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]'

    converter = new Converter source
    converter.remove_type_declaration().s.should.equal expected


  it "removes type declarations with spaces", ->
    source   = '    UIWindow* aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]'
    expected = '    aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]'

    converter = new Converter source
    converter.remove_type_declaration().s.should.equal expected

  it "removes multiple type declarations", ->
    source   =  """
                UIWindow* aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
                UIWindow* bWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]
                """
    expected =  """
                aWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
                bWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]
                """

    converter = new Converter source
    converter.remove_type_declaration().s.should.equal expected

  it 'converts multiline expression', ->
    source   =  """
                UIAlertView* alertA = [[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                 message:@"too many alerts"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];
                UIAlertView* alertB = [[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                 message:@"too many alerts"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];
                [alert show];
                """
    expected =  """
                alertA = UIAlertView.alloc.initWithTitle("Warning",message:"too many alerts",delegate:nil,cancelButtonTitle:"OK",otherButtonTitles:nil)
                alertB = UIAlertView.alloc.initWithTitle("Warning",message:"too many alerts",delegate:nil,cancelButtonTitle:"OK",otherButtonTitles:nil)
                alert.show
                """

    converter = new Converter source
    converter.result().should.equal expected
