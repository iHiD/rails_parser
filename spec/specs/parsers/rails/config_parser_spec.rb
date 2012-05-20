require 'spec_helper'

module RailsParser::Parsers::Rails
  
  describe ApplicationConfigParser do
    
    it "should get get a top-level config value" do 
      content = "config.encoding = 'utf-8'"
      parser = ConfigParser.new 
      parser.process(RubyParser.new.process(content))
      parser.config_options.length.should == 1
      option = parser.config_options[0]
      option.length.should == 1
      option[0].name.should == :encoding
      option[0].arguments[0].should == "utf-8"
    end

    it "should get a nested config values" do 
      content = "config.assets.enabled = true"
      parser = ConfigParser.new 
      parser.process(RubyParser.new.process(content))
      parser.config_options.length.should == 1
      option = parser.config_options[0]
      option.length.should == 2
      option[0].name.should == :assets
      option[0].arguments.should == []
      option[1].name.should == :enabled
      option[1].arguments.should == [:true]
    end

=begin   
    it "should get a nested config values" do
      content = "config.assets.pipeline.paths += ['/lib']"
      parser = ConfigParser.new 
      parser.process(RubyParser.new.process(content))
      parser.config_options.length.should == 1
      option = parser.config_options[0]
      option[0].name.should == :assets
      option[1].name.should == :pipeline
      option[2].name.should == :enabled
      option[2].arguments.should == ['/lib']
    end
 
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