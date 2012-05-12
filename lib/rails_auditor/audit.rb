module RailsAuditor
  class Audit
    
    attr_reader :application_path
    
    def initialize(application_path)
      @application_path = application_path
    end
  end
end