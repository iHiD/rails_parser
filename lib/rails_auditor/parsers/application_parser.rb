module RailsAuditor
  module Parsers
    class ApplicationParser
=begin
      def self.parse(application_path)
        parsed_application = ParsedComponents::ParsedApplication.new(application_path)
      
        # Gems are extracted out to a gemfile_parser
        # This can then be changed later for other methods of finding gems.
        parsed_gemfile = GemfileParser.parse(File.join(application_path, "Gemfile"))
      
        #audit.rails_version = gemfile_auditor.gems["rails"][:specification].version
        #audit.gems = gemfile_auditor.gems
      
        return parsed_application  
      end
=end   
    end
  end
end