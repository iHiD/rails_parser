require 'spec_helper'

module RailsParser::Parsers::Ruby
  
  describe CallTreeParser do
    
    it "should parse a call tree and correctly get descendants" do 
      content = "a.b.c = 'asd'"
      
      parser = CallTreeParser.new
      parser.parse(RubyParser.new.process(content)[1])
      parser.call_tree.length.should == 2
      parser.call_tree[0].name.should == :a
      parser.call_tree[0].arguments.should == []
      parser.call_tree[1].name.should == :b
      parser.call_tree[1].arguments.should == []
    end
    
    it "should parse a call tree and correctly get descendants as a hash" do 
      pending
      content = "a.b.c.d.e.f.g = 'asd'"
      
      parsed_content = RubyParser.new.process(content)
      parser = CallTreeParser.new
      parser.parse(parsed_content[1])
      parser.call_tree.should == {:a => {:b => {:c => {:d => {:e => {:f => {}}}}}}}
    end
  end
end