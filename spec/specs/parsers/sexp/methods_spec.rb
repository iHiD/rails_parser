require 'spec_helper'

module RailsParser
  
  describe Sexp do
    describe "to_hash" do
      it "should convert a s(:hash...) to a hash" do 
        content = {:a => 1, :b => 2, :c => 3}
        exp = Ruby19Parser.new.process("#{content}")
        exp.to_hash.should == content
      end
      it "should convert raise an exception if the content is not a hash" do 
        content = [1,2,3]
        exp = Ruby19Parser.new.process("#{content}")
        lambda{exp.to_hash}.should raise_error(ArgumentError)
      end
      it "can be called by to_hash" do
        content = {:a => 1, :b => 2, :c => 3}
        exp = Ruby19Parser.new.process("#{content}")
        exp.to_h.should == content
      end
    end
    
    describe "to_value" do 
      it "should convert values" do
        Ruby19Parser.new.process("'x'").to_value.should == 'x'
        Ruby19Parser.new.process("1").to_value.should == 1
        Ruby19Parser.new.process(":x").to_value.should == :x
        Ruby19Parser.new.process("true").to_value.should == true
        Ruby19Parser.new.process("false").to_value.should == false
        Ruby19Parser.new.process("nil").to_value.should == nil
        Ruby19Parser.new.process("[1,2,3]").to_value.should == [1,2,3]
        lambda{Ruby19Parser.new.process("x()").to_value}.should raise_error ArgumentError, "Unknown Type: call"
      end
    end
    
    describe "to_a" do
      it "should convert an array" do
        Ruby19Parser.new.process("[1,'2',:a]").to_array.should == [1,'2',:a]
      end
      it "should convert the arguments from a :call" do
        Ruby19Parser.new.process("foobar(:a,:b,:c)").to_array.should == [:a,:b,:c]
      end
      it "should convert raise an exception if the content is not a array" do 
        exp = Ruby19Parser.new.process("{:a => 1, :b => 2, :c => 3}")
        lambda{exp.to_array}.should raise_error(ArgumentError)
      end      
      it "can be called by to_array" do
        Ruby19Parser.new.process("[1,'2',:a]").to_a.should == [1,'2',:a]
      end
    end
  end
  
end