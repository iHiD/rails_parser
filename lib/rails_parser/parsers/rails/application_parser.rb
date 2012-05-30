require 'rails_parser/parsers/rails/config_parser'
require 'rails_parser/parsers/rails/application_config_parser'
require 'rails_parser/parsers/rails/gemfile_parser'

module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Rails #:nodoc:
      
      # = Application Parser
      class ApplicationParser
        def initialize(path)
          @path = path
          @parsers = {}
        end
        
        def application_name
          self.application_config_parser.application_name
        end
        
        def gems_source
          self.gemfile_parser.source
        end
        
        def gems
          self.gemfile_parser.gems
        end
        
        def configuration
          self.application_config_parser.configuration
        end
        
        protected
          def gemfile_parser
            @parsers[:gemfile] ||= GemfileParser.parse_file("#{@path}/Gemfile")
          end
          def application_config_parser
            @parsers[:application_config] ||= ApplicationConfigParser.parse_file("#{@path}/config/application.rb")
          end
      end
    end
  end
end