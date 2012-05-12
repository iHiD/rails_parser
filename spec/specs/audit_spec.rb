require 'spec_helper'

describe RailsAuditor::Audit do
  it "should take a path as the root of the app" do
    audit = RailsAuditor::Audit.new(default_application_path)
    audit.application_path.should == default_application_path
  end
end