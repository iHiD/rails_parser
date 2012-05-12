module RailsAuditor
  class Auditor
    def self.audit
      return Audit.new
    end
  end
end