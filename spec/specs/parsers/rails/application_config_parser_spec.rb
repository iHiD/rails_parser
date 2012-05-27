require 'spec_helper'

module RailsParser::Parsers::Rails
  
  describe ApplicationConfigParser do
    it "should save the app's name" do
      parser = ApplicationConfigParser.parse_file("#{default_application_path}/config/application.rb")
      parser.application_name.should == "DefaultApp"
    end
    
    it "should get an array of config values" do 
      parser = ApplicationConfigParser.parse_file("#{default_application_path}/config/application.rb")
      parser.config_options.should == {
        encoding:"utf-8", 
        filter_parameters: [:password], 
        active_record: {
          whitelist_attributes: true
        }, 
        assets: {
          enabled: true, 
          version: "1.0"
        }
      }
    end
  end
end