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
      
        root_node.find_first_nodes(sexp_type: :command, message:["gem", "group"]) do |node|
          next unless node.message.to_s == "gem"
          parse_gem_node(node, [])
        end
        
        root_node.find_first_nodes(sexp_type: :method_add_block, message:"group") do |node|
        
          groups = []
          node.arguments.values.each do |argument|
            if argument.sexp_type == :array
              groups += argument.array_values.map{|v|v.to_s.to_sym}
            else
              groups << argument.to_s.to_sym
            end
          end
          
          # We have a group, take note of it and find some gems in it
          node.block.find_nodes(sexp_type: :command) do |child_node|
            parse_gem_node(child_node, groups)
          end
        end
        
        # Return a representation of the gemfile
        return Blueprints::GemfileBlueprint.new(@filepath, @gems)
      end
    
      def parse_gem_node(gem_node, groups)
        arguments = gem_node.arguments.values
        name = arguments[0].to_s
        options = {}
            
        # The second argument is optional and can be a version or a hash
        if arguments.length > 1
          if hash_keys = arguments[1].hash_keys 
            append_gem_options!(options, arguments[1], hash_keys)
          else
            options[:version] = arguments[1].to_s
            #self.append_gem_options!(options, arguments[2]) if arguments.length > 2
          end 
        end
      
        add_gem(name, options, groups)
      end
      
      def add_gem(name, options, groups)
        
        parsed_gem = Blueprints::GemBlueprint.new(name, options)
        @gems[parsed_gem.name] ||= {specification: parsed_gem, groups: groups}
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