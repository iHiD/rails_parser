require 'spec_helper'

describe RailsAuditor::Auditor do
  it "should return an audit object when audited" do
    audit = RailsAuditor::Auditor.audit!(default_application_path)
    audit.class.should == RailsAuditor::Audit
  end
  
  it "should set the application path" do
    audit = RailsAuditor::Auditor.audit!(default_application_path)
    audit.application_path.should == default_application_path
  end
  
  it "should retrieve the rails version" do
    audit = RailsAuditor::Auditor.audit!(default_application_path)
    audit.rails_version.should == "3.2.3"
  end
end