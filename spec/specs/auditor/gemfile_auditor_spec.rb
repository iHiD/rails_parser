require 'spec_helper'

describe RailsAuditor::GemfileAuditor do
  
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
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!(@gemfile.path)
      gemfile_auditor.gems.keys.should include 'gem1'
      gemfile_auditor.gems['gem1'][:specification].name.should == "gem1"
    end
  
    it "should return the name and version of a gem" do
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!(@gemfile.path)
      gemfile_auditor.gems['gem2'][:specification].name.should == "gem2"
      gemfile_auditor.gems['gem2'][:specification].version.should == "3.2.1"
    end
  
    it "should return the git repository of a gem" do
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!(@gemfile.path)
      gemfile_auditor.gems['gem3'][:specification].name.should == "gem3"
      gemfile_auditor.gems['gem3'][:specification].git_repository.should == "git://github.com/ihid/gem3"
    end
  
    it "should return the git repository of a gem" do
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!(@gemfile.path)
      gemfile_auditor.gems['gem4'][:specification].name.should == "gem4"
      gemfile_auditor.gems['gem4'][:specification].git_repository.should == "git://github.com/ihid/gem4"
      gemfile_auditor.gems['gem4'][:specification].git_branch.should == "foobar"
    end
  
    it "should return a specification and groups for each gem from a Gemfile" do
      pending
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!("#{default_application_path}/Gemfile")
      gemfile_auditor.gems['rails'].should == {specification:RailsAuditor::Audit::GemSpecification.new("rails", version: "3.2.1"),
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
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!(@gemfile.path)
      gemfile_auditor.gems.size.should == 4
    end
    
    it "should correctly put gems in groups" do
      gemfile_auditor = RailsAuditor::GemfileAuditor.audit!(@gemfile.path)
      gemfile_auditor.gems['gem1'][:groups].should == []
      gemfile_auditor.gems['gem2'][:groups].should == [:test]
      gemfile_auditor.gems['gem3'][:groups].should == [:test, :development]
      gemfile_auditor.gems['gem4'][:groups].should == [:test, :development]
    end
  end
end