require 'rails_auditor/auditor/gemfile_auditor/gem_specification'

module RailsAuditor #:nodoc:
  # = Gemfile Auditor
  #
  # The class inspects a gemfile and extracts information, such as the groups, gems, etc.
  
  # It works like this:
  #
  #   auditor = GemfileAuditor.new("/path/to/Gemfile")
  #   auditor.gems # => {"rails" => {:specification => <GemSpecification>, :groups => [:all]}, ...}
  class GemfileAuditor
    
    attr_reader :gems
    
    def initialize(filepath, gems)
      @filepath = filepath
      @gems = gems
    end
    
    # Takes a filepath and parses it, returning a loaded Gemfile Auditor
    def self.audit!(filepath)
      contents = File.read(filepath)
      gems = {}
      
      # Scan for non-versioned gems
      contents.scan(/^gem\s+["']([^"']+)["']\s*$/).each do |match|
        spec = GemSpecification.new(match[0], {})
        gems[spec.name] ||= {specification: spec, groups: []}
        #gems[spec.name][:groups] << :all
      end
      
      # Scan for versioned gems
      contents.scan(/^gem\s+["']([^"']+)["']\s*,\s*["']([^"']+)["']/).each do |match|
        spec = GemSpecification.new(match[0], version:match[1])
        gems[spec.name] ||= {specification: spec, groups: []}
      end
      
      self.new(filepath, gems)
    end
    
    def rails_version
      gems.values.flatten[]
    end
  end
end
