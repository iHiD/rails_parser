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
    
    def initialize(filepath)
      @filepath = filepath
      @gems = {}
    end
    
    def rails_version
      gems.values.flatten[]
    end
    
    def audit!
      content = File.read(@filepath)
      root_node = Sexp.from_array(Ripper::SexpBuilder.new(content).parse)[1]
      
      root_node.grep_nodes(sexp_type: :command, message:'gem') do |node|
        if node[1].to_s == "gem"
          parse_gem_node(node, [])
          next
        end
        
        #ap node
      end
    end
    
    def parse_gem_node(gem_node, groups)
      arguments = gem_node.arguments.all
      name = arguments[0].to_s
      options = {}
      
      # The second argument is optional and can be a version or a hash
      if arguments.length > 1
        if hash_keys = arguments[1].hash_keys 
          self.append_gem_options!(options, arguments[1], hash_keys)
        else
          options[:version] = arguments[1].to_s 
          self.append_gem_options!(options, arguments[2]) if arguments.length > 2
        end 
      end
      
      spec = Audit::GemSpecification.new(name, options)
      @gems[spec.name] ||= {specification: spec, groups: []}
    end
    
    def append_gem_options!(options, node, hash_keys = nil)
      hash_keys = node.hash_keys unless hash_keys
      hash_keys.each do |key|
        options[key.to_sym] = node.hash_value(key).to_s
      end
    end
    
    # Takes a filepath and parses it, returning a loaded Gemfile Auditor
    def self.audit!(filepath)
      auditor = self.new(filepath)
      auditor.audit!
      auditor
    end
  end
end
