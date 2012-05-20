require 'spec_helper'

module RailsParser::Blueprints::Ruby
  describe MethodCallBlueprint do
  
    it "should save the name" do
      name = "foobar"
      mc = MethodCallBlueprint.new(name)
      mc.name.should == "foobar"
    end
  
    it "should save the arguments" do
      arguments = ["a","b","c"]
      mc = MethodCallBlueprint.new('foobar', arguments: arguments)
      mc.arguments.should == arguments
    end
  end
end