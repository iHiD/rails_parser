require 'spec_helper'

describe RailsAuditor::GemfileAuditor do
  
  it "should return a specification and groups for each gem" do
    gemfile_auditor = RailsAuditor::GemfileAuditor.audit!("#{default_application_path}/Gemfile")
    gemfile_auditor.gems['rails'].should == {specification:RailsAuditor::GemfileAuditor::GemSpecification.new("rails", version: "3.2.1"),
                                              groups: []}
  end
  
  it "should correctly count the gems in a Gemfile" do
    gemfile_auditor = RailsAuditor::GemfileAuditor.audit!("#{default_application_path}/Gemfile")
    gemfile_auditor.gems.size.should == 3
  end
  
  it "should count the gems correctly based on their groups in a Gemfile" do
    pending("Parse this properly")
    #gemfile_auditor = RailsAuditor::GemfileAuditor.audit!("#{default_application_path}/Gemfile")
    #gemfile_auditor.grouped_gems[:all].size.should == 3
    #gemfile_auditor.gems[:development].size.should == 3
    #gemfile_auditor.gems[:production].size.should == 3
    #gemfile_auditor.gems[:test].size.should == 3
  end
end