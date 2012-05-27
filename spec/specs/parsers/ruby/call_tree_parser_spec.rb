require 'spec_helper'

module RailsParser::Parsers::Ruby
  
  describe CallTreeParser do
    
    it "should parse a call tree and correctly get descendants" do 
      content = "a.b.c = 'asd'"
      
      parser = CallTreeParser.new
      parser.parse(Ruby19Parser.new.process(content)[1])
    
      parser.call_tree.should == [{:name=>:a, :arguments=>[]}, {:name=>:b, :arguments=>[]}]
    end
  end
end