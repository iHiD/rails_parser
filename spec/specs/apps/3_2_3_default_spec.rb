require 'spec_helper'

module RailsParser
  
  describe "3.2.3 Application" do
    before :each do
      app_path = File.join(File.dirname(__FILE__), "../../apps/3_2_3_default") 
      @parser = Parsers::Rails::ApplicationParser.new(app_path)
    end
    
    it "should save the app's name" do
      @parser.application_name.should == "DefaultApp"
    end
    
    it "should save the app's gems" do
      @parser.gems.should == {
        :rails          => {:name=>"rails", :groups=>[], :version=>"3.2.3"}, 
        :sqlite3        => {:name=>"sqlite3", :groups=>[]}, 
        :"sass-rails"   => {:name=>"sass-rails", :groups=>[:assets], :version=>"~> 3.2.3"}, 
        :"coffee-rails" => {:name=>"coffee-rails", :groups=>[:assets], :version=>"~> 3.2.1"}, 
        :uglifier       => {:name=>"uglifier", :groups=>[:assets], :version=>">= 1.0.3"}, 
        :"jquery-rails" => {:name=>"jquery-rails", :groups=>[]}}
    end
    
    it "should save the app's gems source" do
      @parser.gems_source.should == "https://rubygems.org"
    end
    
    it "should get an array of config values" do
      @parser.configuration.should == {
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