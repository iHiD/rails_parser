require 'spec_helper'

module RailsParser::Parsers::Rails
  
  describe ApplicationConfigParser do
    
    it "should get get a top-level config value" do
      content = "config.encoding = 'utf-8'"
      parser = ConfigParser.new 
      parser.process(Ruby19Parser.new.process(content))
      parser.configuration.length.should == 1
      parser.configuration.should == {encoding: 'utf-8'}
    end

    it "should get a nested config values" do
      content = "config.assets.enabled = true"
      parser = ConfigParser.new 
      parser.process(Ruby19Parser.new.process(content))
      parser.configuration.should == {assets: {enabled: true}}
    end

    it "should get array values" do
      content = "config.assets.enabled = [1,2,3]"
      parser = ConfigParser.new 
      parser.process(Ruby19Parser.new.process(content))
      parser.configuration.should == {assets: {enabled: [1,2,3]}}
    end

    it "should get self-modifying calls" do
      content = "config.assets.pipeline.paths += ['/lib']"
      parser = ConfigParser.new 
      parser.process(Ruby19Parser.new.process(content))
      parser.configuration.should == {assets: {pipeline: {paths: ['/lib']}}}
    end
    
    it "should only parse config variables" do
      content = <<-EOS
      cat.dog = mouse
      EOS
      parser = ConfigParser.new 
      parser.process(Ruby19Parser.new.process(content))
      parser.configuration.keys.length.should == 0
    end
  end
end