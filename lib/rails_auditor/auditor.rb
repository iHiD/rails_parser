module RailsAuditor
  class Auditor
=begin
    def self.audit!(application_path)
      audit = Audit.new(application_path)
      
      # Gems are extracted out to a gemfile_parser
      # This can then be changed later for other methods of finding gems.
      gemfile_parser = GemfileParser.parse!(File.join(application_path, "Gemfile"))
      
      audit.rails_version = gemfile_auditor.gems["rails"][:specification].version
      audit.gems = gemfile_auditor.gems
      
      return audit
      
    end
=end
  end
end