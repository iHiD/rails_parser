require 'spec_helper'

module RailsAuditor::Parsers::Rails
  describe GemfileParser do

    it "should parse a Gemfile" do
      parser = GemfileParser.new
      parser.parse("#{default_application_path}/Gemfile")
      parser.gems[:rails].should == {blueprint:RailsAuditor::Blueprints::GemBlueprint.new("rails", version: "3.2.1"), groups: []}
    end

    describe "Ungrouped gems" do
      before :each do 
        content = <<-EOS
        gem 'gem1'
        gem 'gem2', '3.2.1'
        gem 'gem3', :git => 'git://github.com/ihid/gem3'
        gem 'gem4', :git => 'git://github.com/ihid/gem4', :branch => "foobar"
        EOS
        
        @gemfile = create_tempfile(content)
        @parser = GemfileParser.new
      end
      
      it "should return the name of a gem" do
        @parser.parse(@gemfile)
        @parser.gems.keys.should include :gem1
        @parser.gems[:gem1][:blueprint].name.should == "gem1"
      end
      
      it "should return the name and version of a gem" do
        @parser.parse(@gemfile)
        @parser.gems[:gem2][:blueprint].name.should == "gem2"
        @parser.gems[:gem2][:blueprint].version.should == "3.2.1"
      end
  
      it "should return the git repository of a gem" do
        @parser.parse(@gemfile)
        @parser.gems[:gem3][:blueprint].name.should == "gem3"
        @parser.gems[:gem3][:blueprint].git_repository.should == "git://github.com/ihid/gem3"
      end
  
      it "should return the git repository of a gem" do
        @parser.parse(@gemfile)
        @parser.gems[:gem4][:blueprint].name.should == "gem4"
        @parser.gems[:gem4][:blueprint].git_repository.should == "git://github.com/ihid/gem4"
        @parser.gems[:gem4][:blueprint].git_branch.should == "foobar"
      end
    end

    describe "Grouped gems" do
      before :each do 
        content = <<-EOS
        gem 'gem1'
        group :test, :development do
          gem 'gem2', '3.2.1'
          gem 'gem3'
        end
        gem 'gem4', :group => :development
        EOS
    
        @gemfile = create_tempfile(content)
        @parser = GemfileParser.new
      end
  
      it "should correctly count the gems in a Gemfile" do
        @parser.parse(@gemfile)
        @parser.gems.size.should == 4
      end
    
      it "should correctly put gems in groups" do
        @parser.parse(@gemfile)
        @parser.gems[:gem1][:groups].should == []
        @parser.gems[:gem2][:groups].should == [:test, :development]
        @parser.gems[:gem3][:groups].should == [:test, :development]
        @parser.gems[:gem4][:groups].should == [:development]
      end
    end
    
    it "should save the source" do
      content = <<-EOS
      source 'https://rubygems.org'
      gem 'gem1'
      EOS
      @gemfile = create_tempfile(content)
      @parser = GemfileParser.new
      @parser.parse(@gemfile)
      @parser.source.should == "https://rubygems.org"
    end
  end
end