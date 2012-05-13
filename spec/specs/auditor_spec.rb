require 'spec_helper'

=begin
describe RailsAuditor::Auditor do
  it "should return an audit object when audited" do
    pending
    audit = RailsAuditor::Auditor.audit!(default_application_path)
    audit.class.should == RailsAuditor::Audit
  end
  
  it "should set the application path" do
    pending
    audit = RailsAuditor::Auditor.audit!(default_application_path)
    audit.application_path.should == default_application_path
  end
  
  it "should retrieve the rails version" do
    pending
    audit = RailsAuditor::Auditor.audit!(default_application_path)
    audit.rails_version.should == "3.2.3"
  end
end
=end