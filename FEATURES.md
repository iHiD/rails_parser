# Functionality
parser = GemfileParser.new
parser.parse("/path/to/Gemfile")
parser.gems = {rails: {blueprint: <Blueprints::GemBlueprint>, groups: [:test, :development]}}