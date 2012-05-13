require 'spec_helper'

module RailsAuditor::ParsedComponents
  describe ParsedGem do
  
    it "should save the name" do
      name = "foobar"
      g = ParsedGem.new(name)
      g.name.should == "foobar"
    end
  
    it "should save the version" do
      version = "1.2.3"
      g = ParsedGem.new("foobar", version: version)
      g.version.should == version
    end
  
    it "should save the git repository" do
      repository = "git://github.com/ihid/ihid.git"
      g = ParsedGem.new("foobar", git: repository)
      g.git_repository.should == repository
    end
  
    it "should save the version" do
      branch = "foobar"
      g = ParsedGem.new("foobar", branch: branch)
      g.git_branch.should == branch
    end
  
    it "should compare two gems by name" do
      gem1 = ParsedGem.new("foobar", version: "asd")
      gem2 = ParsedGem.new("foobar", version: "qwe")
      gem3 = ParsedGem.new("foobar2", version: "qwe")
    
      gem1.should == gem2
      gem1.should_not == gem3
    end
  end
end