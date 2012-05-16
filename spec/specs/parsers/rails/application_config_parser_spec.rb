require 'spec_helper'

module RailsAuditor::Parsers::Rails
  
  describe ApplicationConfigParser do
    it "should save the app's name" do
      parser = ApplicationConfigParser.new 
      parser.parse("#{default_application_path}/config/application.rb")
      parser.application_name.should == "DefaultApp"
    end
  end
end