require 'spec_helper'

module RailsParser::Parsers::Rails
  
  describe ApplicationConfigParser do
    it "should save the app's name" do
      parser = ApplicationConfigParser.parse_file("#{default_application_path}/config/application.rb")
      parser.application_name.should == "DefaultApp"
    end
    
    it "should get an array of config values" do 
      parser = ApplicationConfigParser.parse_file("#{default_application_path}/config/application.rb")
      ap parser.config_options
      parser.config_options.length.should == 20
    end
  end
end