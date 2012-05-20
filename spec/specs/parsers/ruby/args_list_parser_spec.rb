require 'spec_helper'

module RailsParser::Parsers::Ruby
  
  describe ArgsListParser do
    
    it "should parse a list of arguments" do 
      content = "m(1,2,3)"
      
      parser = ArgsListParser.new
      parser.parse(RubyParser.new.process(content)[3])
      
      parser.arguments.length.should == 3
    end
    
    it "should parse number arguments" do 
      content = "m(1)"
      
      parser = ArgsListParser.new
      parser.parse(RubyParser.new.process(content)[3])
      
      parser.arguments[0][:type].should == :literal
      parser.arguments[0][:value].should == 1
    end
    
    it "should parse symbol arguments" do 
      content = "m(:a)"
      
      parser = ArgsListParser.new
      parser.parse(RubyParser.new.process(content)[3])
      
      parser.arguments[0][:type].should == :literal
      parser.arguments[0][:value].should == :a
    end
    
    it "should parse string arguments" do
      content = "m('asd')"
      
      parser = ArgsListParser.new
      parser.parse(RubyParser.new.process(content)[3])
      
      parser.arguments[0][:type].should == :string
      parser.arguments[0][:value].should == 'asd'
    end
    
    it "should parse method call arguments" do
      content = "m(asd)"
      
      parser = ArgsListParser.new
      parser.parse(RubyParser.new.process(content)[3])
      
      parser.arguments[0][:type].should == :method_call
      parser.arguments[0][:value].class.should == RailsParser::Blueprints::Ruby::MethodCallBlueprint
      parser.arguments[0][:value].name.should == :asd
    end
  end
end