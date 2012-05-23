module RailsParser #:nodoc:
  module Parsers #:nodoc:
    class BaseParser < SexpProcessor
      def initialize
        super
        self.auto_shift_type = false
        self.require_empty = false
      end
        
      def parse(exp)
        process(exp)
      end 
      
      def parse_file(filepath)
        content = File.read(filepath)
        exp = RubyParser.new.process(content)
        process(exp)
      end
      
      def self.parse(exp)
        parser = self.new
        parser.parse(exp)
        parser
      end
      
      def self.parse_file(filepath)
        parser = self.new
        parser.parse_file(filepath)
        parser
      end
    end
  end
end