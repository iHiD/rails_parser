require 'spec_helper'

describe RailsAuditor::GemfileAuditor::GemSpecification do
  
  it "should save the name" do
    name = "foobar"
    g = RailsAuditor::GemfileAuditor::GemSpecification.new(name)
    g.name.should == "foobar"
  end
  
  it "should save the version" do
    version = "1.2.3"
    g = RailsAuditor::GemfileAuditor::GemSpecification.new("foobar", version: version)
    g.version.should == version
  end
  
  it "should compare two gems by name" do
    gem1 = RailsAuditor::GemfileAuditor::GemSpecification.new("foobar", version: "asd")
    gem2 = RailsAuditor::GemfileAuditor::GemSpecification.new("foobar", version: "qwe")
    gem3 = RailsAuditor::GemfileAuditor::GemSpecification.new("foobar2", version: "qwe")
    
    gem1.should == gem2
    gem1.should_not == gem3
  end
end