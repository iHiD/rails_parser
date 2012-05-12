module RailsAuditor
  class Auditor
    def self.audit(application_path)
      return Audit.new(application_path)
    end
  end
end