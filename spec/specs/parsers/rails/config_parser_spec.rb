require 'spec_helper'

module RailsParser::Parsers::Rails
  
  describe ApplicationConfigParser do
    
    it "should get get a top-level config value" do 
      content = <<-EOS
      config.encoding = "utf-8"
      EOS
      parser = ConfigParser.new 
      parser.process(RubyParser.new.process(content))
      parser.config_options[:encoding].should == "utf-8"
    end

    it "should get a nested config values" do 
      content = <<-EOS
      config.assets.enabled = true
      EOS
      parser = ConfigParser.new 
      parser.process(RubyParser.new.process(content))
      parser.config_options[:assets][:enabled].should == true
    end

=begin    
    it "should only parse config variables" do
      content = <<-EOS
      cat.dog = mouse
      EOS
      parser = ConfigParser.new 
      parser.process(RubyParser.new.process(content))
      parser.config_options.keys.length.should == 0
    end
=end
  end
end