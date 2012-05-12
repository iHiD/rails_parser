require 'rails_auditor/audit/gem_specification'

module RailsAuditor
  class Audit
    
    attr_accessor :application_path, :rails_version, :gems
    
    def initialize(application_path)
      @application_path = application_path
    end
  end
end