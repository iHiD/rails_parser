require 'spec_helper'

module RailsAuditor::Parsers
  describe GemfileParser do
  
    describe "Ungrouped gems" do
      before :each do 
        content = <<-EOS
        gem 'gem1'
        gem 'gem2', '3.2.1'
        gem 'gem3', :git => 'git://github.com/ihid/gem3'
        gem 'gem4', :git => 'git://github.com/ihid/gem4', branch: "foobar"
        EOS
    
        @gemfile = create_tempfile(content)
      end
  
      it "should return the name of a gem" do
        parsed_gemfile = GemfileParser.parse(@gemfile.path)
        parsed_gemfile.gems.keys.should include 'gem1'
        parsed_gemfile.gems['gem1'][:specification].name.should == "gem1"
      end
  
      it "should return the name and version of a gem" do
        parsed_gemfile = GemfileParser.parse(@gemfile.path)
        parsed_gemfile.gems['gem2'][:specification].name.should == "gem2"
        parsed_gemfile.gems['gem2'][:specification].version.should == "3.2.1"
      end
  
      it "should return the git repository of a gem" do
        parsed_gemfile = GemfileParser.parse(@gemfile.path)
        parsed_gemfile.gems['gem3'][:specification].name.should == "gem3"
        parsed_gemfile.gems['gem3'][:specification].git_repository.should == "git://github.com/ihid/gem3"
      end
  
      it "should return the git repository of a gem" do
        parsed_gemfile = GemfileParser.parse(@gemfile.path)
        parsed_gemfile.gems['gem4'][:specification].name.should == "gem4"
        parsed_gemfile.gems['gem4'][:specification].git_repository.should == "git://github.com/ihid/gem4"
        parsed_gemfile.gems['gem4'][:specification].git_branch.should == "foobar"
      end
  
      it "should return a specification and groups for each gem from a Gemfile" do
        pending
        parsed_gemfile = GemfileParser.parse("#{default_application_path}/Gemfile")
        parsed_gemfile.gems['rails'].should == {specification:RailsAuditor::BluePrints::ParsedGem.new("rails", version: "3.2.1"),
                                                  groups: []}
      end
    end
  
    describe "Grouped gems" do
      before :each do 
        content = <<-EOS
        gem 'gem1'
        group :test do
          gem 'gem2', '3.2.1'
        end
        group [:development, 'test'] do
          gem 'gem3', :git => 'git://github.com/ihid/gem3'
          gem 'gem4', :git => 'git://github.com/ihid/gem4', branch: "foobar"
        end
        EOS
    
        @gemfile = create_tempfile(content)
      end
  
      it "should correctly count the gems in a Gemfile" do
        parsed_gemfile = GemfileParser.parse(@gemfile.path)
        parsed_gemfile.gems.size.should == 4
      end
    
      it "should correctly put gems in groups" do
        parsed_gemfile = GemfileParser.parse(@gemfile.path)
        parsed_gemfile.gems['gem1'][:groups].should == []
        parsed_gemfile.gems['gem2'][:groups].should == [:test]
        parsed_gemfile.gems['gem3'][:groups].should == [:development, :test]
        parsed_gemfile.gems['gem4'][:groups].should == [:development, :test]
      end
    end
  end
end