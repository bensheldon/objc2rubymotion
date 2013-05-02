chai.should()

describe "Sanity", ->
  it "1 should == 1", ->
    1.should.equal 1


describe "Converter", ->
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
