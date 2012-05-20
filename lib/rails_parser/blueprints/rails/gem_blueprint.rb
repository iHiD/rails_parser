module RailsParser #:nodoc:
  module Blueprints #:nodoc:
    module Rails
      class GemBlueprint
      
        attr_reader :name, :version, :git_repository, :git_branch
      
        def initialize(name, options = {})
          @name = name
        
          @version        = options[:version]
          @git_repository = options[:git]
          @git_branch     = options[:branch]
        end
      
        def ==(other_gem)
          return name == other_gem.name
        end
      end
    end
  end
end