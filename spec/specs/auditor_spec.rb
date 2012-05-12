require 'spec_helper'

describe RailsAuditor::Auditor do
  it "should return an audit object when audited" do
    audit = RailsAuditor::Auditor.audit(default_application_path)
    audit.class.should == RailsAuditor::Audit
  end
  
  it "should take a path as the root of the app" do
    audit = RailsAuditor::Auditor.audit(default_application_path)
    audit.application_path.should == default_application_path
  end
end