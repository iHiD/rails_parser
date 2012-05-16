module RailsAuditor #:nodoc:
  module Parsers #:nodoc:
    # = Gemfile Parser
    #
    # The class inspects a gemfile and extracts the gems, along with their groups
    #
    # It works like this:
    #
    #   parsed_gemfile = GemfileParser.parse("/path/to/Gemfile")
    #   parsed_gemfile.gems # => {"rails" => {:blueprint => <ParsedGem>, :groups => [:all]}, ...}
    class GemfileParser < SexpProcessor
      
      attr_reader :gems
    
      def initialize
        super
        self.auto_shift_type = true
        @gems = {}
        @current_groups = []
      end
      
      def parse(gemfile)
        content = File.read(gemfile)
        parser = RubyParser.new
        sexp = parser.process(content)
        process(sexp)
      end
      
      def process_call(exp)
        exp.shift
        command = exp.shift
        args_exp = exp.shift
        
        case command
        when :gem
          parse_gem(args_exp[1], args_exp[2]) 
        when :group
          args_exp.shift
          @current_groups = []
          args_exp.each do |arg|
            @current_groups << arg[1]
          end
        end
        return exp
      end
      
      def process_argslist(exp)
      end
      
      def process_iter(exp)
        while exp.length > 0
          process(exp.shift)
        end
        @current_groups = []
        return exp
      end
      
      def parse_gem(name_exp, args_exp)
        name = name_exp[1]
        options = {}
      
        case args_exp[0]
        when :str
          options[:version] = args_exp[1]
          
        when :hash
          args_exp.shift # Get rid of :hash
          while args_exp.length > 0
            options[args_exp.shift[1]] = args_exp.shift[1]
          end
        end if args_exp
        
        gem_group = options.delete(:group)
        
        @gems[name.to_sym] ||= {blueprint: Blueprints::GemBlueprint.new(name, options), groups: []}
        @gems[name.to_sym][:groups] << gem_group if gem_group
        @gems[name.to_sym][:groups] += @current_groups
      end
    end
  end
end
    
=begin
    
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
        return 
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
        @gems[parsed_gem.name] ||= {blueprint: parsed_gem, groups: groups}
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
=end