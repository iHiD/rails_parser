require 'spec_helper'

module RailsParser::Parsers::Rails
  
  describe ApplicationConfigParser do
    before :each do 
      @parser = ApplicationParser.new(default_application_path)
    end
    
    it "should save the app's name" do
      @parser.application_name.should_not be_empty
    end
    
    it "should save the app's gems" do
      @parser.gems.should_not be_empty
    end
    
    it "should save the app's gems source" do
      @parser.gems_source.should_not be_empty
    end
    
    it "should get an array of config values" do
      @parser.configuration.should_not be_empty
    end
  end
end