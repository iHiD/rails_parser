require 'spec_helper'

describe RailsAuditor::Auditor do
  it "should respond an audit object for audit" do
    RailsAuditor::Auditor.audit.class.should == RailsAuditor::Audit
  end
end