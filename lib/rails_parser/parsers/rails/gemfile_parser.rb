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
          arguments_exp = exp[3]
          
          case exp[2]
          when :gem
            parse_gem(arguments_exp[1][1], arguments_exp[2..-1][0]) 
          when :group
            arguments_exp.shift
            @current_groups = []
            arguments_exp.each do |arg|
              @current_groups << arg[1]
            end
          when :source
            @source = arguments_exp[1][1]
          end
          exp
        end
      
        def process_iter(exp)
          exp[1..-1].each {|node| process(node) }
          @current_groups = []
          exp
        end
      
        def parse_gem(name, arguments_exp)
          
          options = {}
          case arguments_exp.shift
          when :str
            options[:version] = arguments_exp[0]
          
          when :hash
            while arguments_exp.length > 0
              options[arguments_exp.shift[1]] = arguments_exp.shift[1]
            end
          end if arguments_exp
        
          gem_group = options.delete(:group)
        
          @gems[name.to_sym] ||= {blueprint: Blueprints::Rails::GemBlueprint.new(name, options), groups: []}
          @gems[name.to_sym][:groups] << gem_group if gem_group
          @gems[name.to_sym][:groups] += @current_groups
        end
      end
    end
  end
end