module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Rails #:nodoc:
      # = Gemfile Parser
      #
      # The class inspects a gemfile and extracts the source and the gems
      #
      # It works like this:
      # parser = GemfileParser.new 
      # parser.parse("/path/to/Gemfile")
      # parser.gems = {rails: {blueprint: <Blueprints::GemBlueprint>, groups: [:test, :development]}}
      class GemfileParser < RailsParser::Parsers::BaseParser
      
        attr_reader :gems
        attr_reader :source
    
        def initialize
          super
          @gems = {}
          @current_groups = []
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
          when :source
            @source = args_exp[1][1]
          end
          return exp
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
        
          @gems[name.to_sym] ||= {blueprint: Blueprints::Rails::GemBlueprint.new(name, options), groups: []}
          @gems[name.to_sym][:groups] << gem_group if gem_group
          @gems[name.to_sym][:groups] += @current_groups
        end
      end
    end
  end
end