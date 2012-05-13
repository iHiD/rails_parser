module RailsAuditor #:nodoc:
  module Parsers #:nodoc:
    # = Gemfile Parser
    #
    # The class inspects a gemfile and extracts the gems, along with their groups
    #
    # It works like this:
    #
    #   parsed_gemfile = GemfileParser.parse("/path/to/Gemfile")
    #   parsed_gemfile.gems # => {"rails" => {:specification => <ParsedGem>, :groups => [:all]}, ...}
    class GemfileParser
    
      attr_reader :parsed_gemfile
    
      def initialize(filepath)
        @filepath = filepath
        @gems = {}
      end
    
      def parse
        content = File.read(@filepath)
        root_node = Sexp.from_array(Ripper::SexpBuilder.new(content).parse)[1]
      
        root_node.grep_nodes(sexp_type: :command, message:'gem') do |node|
          if node[1].to_s == "gem"
            parse_gem_node(node, [])
            next
          end
        
          #ap node
        end
        
        # Return a representation of the gemfile
        return Blueprints::GemfileBlueprint.new(@filepath, @gems)
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
      
        add_gem(name, options, [])
      end
      
      def add_gem(name, options, groups)
        parsed_gem = Blueprints::GemBlueprint.new(name, options)
        @gems[parsed_gem.name] ||= {specification: parsed_gem, groups: []}
      end
    
      def append_gem_options!(options, node, hash_keys = nil)
        hash_keys = node.hash_keys unless hash_keys
        hash_keys.each do |key|
          options[key.to_sym] = node.hash_value(key).to_s
        end
      end
    
      # Takes a filepath and parses it, returning a loaded Gemfile Auditor
      def self.parse(filepath)
        parser = self.new(filepath)
        return parser.parse
      end
    end
  end
end