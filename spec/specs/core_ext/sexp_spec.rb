require 'spec_helper'

# This library is taken from http://rails-bestpractices.com/ an is released with the following licence:
=begin
Copyright (c) 2009 - 2012 Richard Huang (flyerhzm@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

def parse_content(content)
  Sexp.from_array(Ripper::SexpBuilder.new(content).parse)[1]
end

describe Sexp do

  describe "parsing methods" do 
    before :each do 
      content = <<-EOF
      class MyClass
        def my_method(my_var)
          @my_var = my_var
          my_var.my_method = "my_value"
        end
      end
      EOF
      @node = parse_content(content)
    end
    
    it "should return the correct sext" do
      @node.should == s(:stmts_add, s(:stmts_new), s(:class, s(:const_ref, s(:@const, "MyClass", s(1, 12))), nil, s(:bodystmt, s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), nil, nil, nil)))
    end

    it "should return all children" do
      nodes = @node.children
      nodes.should == [s(:stmts_new), s(:class, s(:const_ref, s(:@const, "MyClass", s(1, 12))), nil, s(:bodystmt, s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), nil, nil, nil))]
    end

    it "should return all descendants" do
      nodes = @node.descendants
      nodes.should == [s(:stmts_new), s(:class, s(:const_ref, s(:@const, "MyClass", s(1, 12))), nil, s(:bodystmt, s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), nil, nil, nil)), s(:const_ref, s(:@const, "MyClass", s(1, 12))), s(:@const, "MyClass", s(1, 12)), s(1, 12), s(:bodystmt, s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), nil, nil, nil), s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil)), s(:@ident, "my_method", s(2, 12)), s(2, 12), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil), s(s(:@ident, "my_var", s(2, 22))), s(:@ident, "my_var", s(2, 22)), s(2, 22), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil), s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20)))), s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:@ivar, "@my_var", s(3, 10)), s(3, 10), s(:var_ref, s(:@ident, "my_var", s(3, 20))), s(:@ident, "my_var", s(3, 20)), s(3, 20), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30))))), s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:var_ref, s(:@ident, "my_var", s(4, 10))), s(:@ident, "my_var", s(4, 10)), s(4, 10), s(:@ident, "my_method", s(4, 17)), s(4, 17), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))), s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30))), s(:string_content), s(:@tstring_content, "my_value", s(4, 30)), s(4, 30)]
    end

    it "should yield for all descendants" do
      nodes = []
      @node.descendants { |node| nodes << node }
      nodes.should == [s(:stmts_new), s(:class, s(:const_ref, s(:@const, "MyClass", s(1, 12))), nil, s(:bodystmt, s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), nil, nil, nil)), s(:const_ref, s(:@const, "MyClass", s(1, 12))), s(:@const, "MyClass", s(1, 12)), s(1, 12), s(:bodystmt, s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), nil, nil, nil), s(:stmts_add, s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil))), s(:stmts_new), s(:def, s(:@ident, "my_method", s(2, 12)), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil)), s(:@ident, "my_method", s(2, 12)), s(2, 12), s(:paren, s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil)), s(:params, s(s(:@ident, "my_var", s(2, 22))), nil, nil, nil, nil), s(s(:@ident, "my_var", s(2, 22))), s(:@ident, "my_var", s(2, 22)), s(2, 22), s(:bodystmt, s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), nil, nil, nil), s(:stmts_add, s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))))), s(:stmts_add, s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20))))), s(:stmts_new), s(:assign, s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:var_ref, s(:@ident, "my_var", s(3, 20)))), s(:var_field, s(:@ivar, "@my_var", s(3, 10))), s(:@ivar, "@my_var", s(3, 10)), s(3, 10), s(:var_ref, s(:@ident, "my_var", s(3, 20))), s(:@ident, "my_var", s(3, 20)), s(3, 20), s(:assign, s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30))))), s(:field, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:var_ref, s(:@ident, "my_var", s(4, 10))), s(:@ident, "my_var", s(4, 10)), s(4, 10), s(:@ident, "my_method", s(4, 17)), s(4, 17), s(:string_literal, s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30)))), s(:string_add, s(:string_content), s(:@tstring_content, "my_value", s(4, 30))), s(:string_content), s(:@tstring_content, "my_value", s(4, 30)), s(4, 30)]
    end
  end
  
  describe "find_nodes" do
    before :each do
      content = <<-EOF
      class MyClass
        def my_method(my_var)
          @my_var = my_var
          my_var.my_method("my_value")
          my_other_var.my_method("my_value")
        end
      end
      EOF
      @node = parse_content(content)
    end
    
    it "should get all nodes with a specific type" do 
      nodes = @node.find_nodes(:sexp_type => :call)
      nodes.should == [s(:call, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:call, s(:vcall, s(:@ident, "my_other_var", s(5, 10))), :".", s(:@ident, "my_method", s(5, 23)))] 
    end
    
    it "should yield for each node with a specific type" do 
      nodes = []
      @node.find_nodes(:sexp_type => :call) {|node| nodes << node }
      nodes.should == [s(:call, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:call, s(:vcall, s(:@ident, "my_other_var", s(5, 10))), :".", s(:@ident, "my_method", s(5, 23)))] 
    end

    it "should get the call nodes with subject my_var" do
      nodes = @node.find_nodes(:sexp_type => :call, :subject => "my_var")
      nodes.should == [s(:call, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17)))]
    end

    it "should get the call nodes with different messages" do
      nodes = @node.find_nodes(:sexp_type => :call, :message => ["my_var", "my_method"])
      nodes.should == [s(:call, s(:var_ref, s(:@ident, "my_var", s(4, 10))), :".", s(:@ident, "my_method", s(4, 17))), s(:call, s(:vcall, s(:@ident, "my_other_var", s(5, 10))), :".", s(:@ident, "my_method", s(5, 23)))]
    end

    it "should get the var_ref node with to_s" do
      nodes = @node.find_nodes(:sexp_type => :var_ref, :to_s => "my_var")
      nodes.should == [s(:var_ref, s(:@ident, "my_var", s(3, 20))), s(:var_ref, s(:@ident, "my_var", s(4, 10)))]
    end
  end

  describe "find_node" do
    before :each do
      content = <<-EOF
      def show
        current_user.posts.find(params[:id])
      end
      EOF
      @node = parse_content(content)
    end

    it "should get first node with empty argument" do
      node = @node.find_node(:sexp_type => :call, :subject => "current_user")
      node.should == s(:call, s(:vcall, s(:@ident, "current_user", s(2, 8))), :".", s(:@ident, "posts", s(2, 21)))
    end
  end

  describe "find_first_nodes" do
    before :each do
      content = <<-EOF
      gem "gem1"
      group "group1" do 
        gem "gem2"
      end
      gem "gem3"
      magic "foobar"
      EOF
      @node = parse_content(content)
    end

    it "should get first nodes that match type" do
      nodes = @node.find_first_nodes(:sexp_type => :command)
      nodes.size.should == 4
    end

    it "should get first nodes that match arguments" do
      nodes = @node.find_first_nodes(:sexp_type => :command, :message => ["gem", "group"])
      nodes.size.should == 3
    end

    it "should get first nodes that match arguments" do
      nodes = []
      @node.find_first_nodes(:sexp_type => :command, :message => ["gem", "group"]) {|node|nodes << node}
      nodes.size.should == 3
    end
  end
  

  describe "arguments" do
    it "should get the arguments of command" do
      node = parse_content("resources :posts do; end").find_node(:sexp_type => :command)
      node.arguments.sexp_type.should == :args_add_block
    end

    it "should get the arguments of command_call" do
      node = parse_content("map.resources :posts do; end").find_node(:sexp_type => :command_call)
      node.arguments.sexp_type.should == :args_add_block
    end

    it "should get the arguments of method_add_arg" do
      node = parse_content("User.find(:all)").find_node(:sexp_type => :method_add_arg)
      node.arguments.sexp_type.should == :args_add_block
    end

    it "should get the arguments of method_add_block" do
      node = parse_content("Post.save(false) do; end").find_node(:sexp_type => :method_add_block)
      node.arguments.sexp_type.should == :args_add_block
    end
  end

  describe "argument" do
    it "should get the argument of binary" do
      node = parse_content("user == current_user").find_node(:sexp_type => :binary)
      node.argument.to_s.should == "current_user"
    end
  end

  describe "argument_values" do
    it "should get all arguments" do
      node = parse_content("puts 'hello', 'world'").find_node(:sexp_type => :args_add_block)
      node.values.map(&:to_s).should == ["hello", "world"]
    end

    it "should get all arguments with &:" do
      node = parse_content("user.posts.map(&:title)").find_node(:sexp_type => :args_add_block)
      node.values.map(&:to_s).should == ["title"]
    end

    it "no error for args_add_star" do
      node = parse_content("send(:\"\#{route}_url\", *args)").find_node(:sexp_type => :args_add_block)
      lambda { node.values }.should_not raise_error
    end
  end

  describe "hash_keys" do
    it "should get hash_keys for hash node" do
      node = parse_content("{first_name: 'Richard', last_name: 'Huang'}").find_node(:sexp_type => :hash)
      node.hash_keys.should == ["first_name", "last_name"]
    end

    it "should get hash_keys for bare_assoc_hash" do
      node = parse_content("add_user :user, first_name: 'Richard', last_name: 'Huang'").find_node(:sexp_type => :bare_assoc_hash)
      node.hash_keys.should == ["first_name", "last_name"]
    end
  end

  describe "hash_values" do
    it "should get hash_values for hash node" do
      node = parse_content("{first_name: 'Richard', last_name: 'Huang'}").find_node(:sexp_type => :hash)
      node.hash_values.map(&:to_s).should == ["Richard", "Huang"]
    end

    it "should get hash_values for bare_assoc_hash" do
      node = parse_content("add_user :user, first_name: 'Richard', last_name: 'Huang'").find_node(:sexp_type => :bare_assoc_hash)
      node.hash_values.map(&:to_s).should == ["Richard", "Huang"]
    end
  end

  describe "hash_value" do
    it "should get value for hash node" do
      node = parse_content("{first_name: 'Richard', last_name: 'Huang'}").find_node(:sexp_type => :hash)
      node.hash_value("first_name").to_s.should == "Richard"
      node.hash_value("last_name").to_s.should == "Huang"
    end

    it "should get value for bare_assoc_hash" do
      node = parse_content("add_user :user, first_name: 'Richard', last_name: 'Huang'").find_node(:sexp_type => :bare_assoc_hash)
      node.hash_value("first_name").to_s.should == "Richard"
      node.hash_value("last_name").to_s.should == "Huang"
    end
  end

  describe "array_values" do
    it "should get array values" do
      node = parse_content("['first_name', 'last_name']").find_node(:sexp_type => :array)
      node.array_values.map(&:to_s).should == ["first_name", "last_name"]
    end

    it "should get empty array values" do
      node = parse_content("[]").find_node(:sexp_type => :array)
      node.array_values.should == []
    end

    it "should get array value with qwords" do
      node = parse_content("%w(first_name last_name)").find_node(:sexp_type => :qwords_add)
      node.array_values.map(&:to_s).should == ["first_name", "last_name"]
    end
  end

  describe "body" do
    it "should get body of class" do
      node = parse_content("class User; end").find_node(:sexp_type => :class)
      node.body.sexp_type.should == :bodystmt
    end

    it "should get body of def" do
      node = parse_content("def login; end").find_node(:sexp_type => :def)
      node.body.sexp_type.should == :bodystmt
    end

    it "should get body of defs" do
      node = parse_content("def self.login; end").find_node(:sexp_type => :defs)
      node.body.sexp_type.should == :bodystmt
    end

    it "should get body of module" do
      node = parse_content("module Enumerable; end").find_node(:sexp_type => :module)
      node.body.sexp_type.should == :bodystmt
    end

    it "should get body of if" do
      node = parse_content("if true; puts 'hello world'; end").find_node(:sexp_type => :if)
      node.body.sexp_type.should == :stmts_add
    end

    it "should get body of elsif" do
      node = parse_content("if true; elsif true; puts 'hello world'; end").find_node(:sexp_type => :elsif)
      node.body.sexp_type.should == :stmts_add
    end

    it "should get body of unless" do
      node = parse_content("unless true; puts 'hello world'; end").find_node(:sexp_type => :unless)
      node.body.sexp_type.should == :stmts_add
    end

    it "should get body of else" do
      node = parse_content("if true; else; puts 'hello world'; end").find_node(:sexp_type => :else)
      node.body.sexp_type.should == :stmts_add
    end
  end

  describe "block" do
    it "sould get block of method_add_block node" do
      node = parse_content("resources :posts do; resources :comments; end").find_node(:sexp_type => :method_add_block)
      node.block.sexp_type.should == :do_block
    end
  end
  
=begin
  describe "line" do
    before :each do
      content = <<-EOF
      class Demo
        def test
          ActiveRecord::Base.connection
        end
        alias :test_new :test
      end
      EOF
      @node = parse_content(content)
    end

    it "should return class line" do
      @node.find_node(:sexp_type => :class).line.should == 1
    end

    it "should return def line" do
      @node.find_node(:sexp_type => :def).line.should == 2
    end

    it "should return const line" do
      @node.find_node(:sexp_type => :const_ref).line.should == 1
    end

    it "should return const path line" do
      @node.find_node(:sexp_type => :const_path_ref).line.should == 3
    end

    it "should return alias line" do
      @node.find_node(:sexp_type => :alias).line.should == 5
    end
  end

  describe "find_nodes_count" do
    before :each do
      content = <<-EOF
      def show
        current_user.posts.find(params[:id])
      end
      EOF
      @node = parse_content(content)
    end

    it "should get the count of call nodes" do
      @node.find_nodes_count(:sexp_type => :call).should == 2
    end
  end

  describe "subject" do
    it "should get subject of assign node" do
      node = parse_content("user.name = params[:name]").find_node(:sexp_type => :assign)
      subject = node.subject
      subject.sexp_type.should == :field
      subject.subject.to_s.should == "user"
      subject.message.to_s.should == "name"
    end

    it "should get subject of field node" do
      node = parse_content("user.name = params[:name]").find_node(:sexp_type => :field)
      node.subject.to_s.should == "user"
    end

    it "should get subject of call node" do
      node = parse_content("user.name").find_node(:sexp_type => :call)
      node.subject.to_s.should == "user"
    end

    it "should get subject of binary" do
      node = parse_content("user == 'user_name'").find_node(:sexp_type => :binary)
      node.subject.to_s.should == "user"
    end

    it "should get subject of command_call" do
      content = <<-EOF
      map.resources :posts do
      end
      EOF
      node = parse_content(content).find_node(:sexp_type => :command_call)
      node.subject.to_s.should == "map"
    end

    it "should get subject of method_add_arg" do
      node = parse_content("Post.find(:all)").find_node(:sexp_type => :method_add_arg)
      node.subject.to_s.should == "Post"
    end

    it "should get subject of method_add_block" do
      node = parse_content("Post.save do; end").find_node(:sexp_type => :method_add_block)
      node.subject.to_s.should == "Post"
    end
  end

  describe "module_name" do
    it "should get module name of module node" do
      node = parse_content("module Admin; end").find_node(:sexp_type => :module)
      node.module_name.to_s.should == "Admin"
    end
  end

  describe "class_name" do
    it "should get class name of class node" do
      node = parse_content("class User; end").find_node(:sexp_type => :class)
      node.class_name.to_s.should == "User"
    end
  end

  describe "base_class" do
    it "should get base class of class node" do
      node = parse_content("class User < ActiveRecord::Base; end").find_node(:sexp_type => :class)
      node.base_class.to_s.should == "ActiveRecord::Base"
    end
  end

  describe "left_value" do
    it "should get the left value of assign" do
      node = parse_content("user = current_user").find_node(:sexp_type => :assign)
      node.left_value.to_s.should == "user"
    end
  end

  describe "right_value" do
    it "should get the right value of assign" do
      node = parse_content("user = current_user").find_node(:sexp_type => :assign)
      node.right_value.to_s.should == "current_user"
    end
  end

  describe "message" do
    it "should get the message of command" do
      node = parse_content("has_many :projects").find_node(:sexp_type => :command)
      node.message.to_s.should == "has_many"
    end

    it "should get the message of command_call" do
      node = parse_content("map.resources :posts do; end").find_node(:sexp_type => :command_call)
      node.message.to_s.should == "resources"
    end

    it "should get the message of field" do
      node = parse_content("user.name = 'test'").find_node(:sexp_type => :field)
      node.message.to_s.should == "name"
    end

    it "should get the message of call" do
      node = parse_content("user.name").find_node(:sexp_type => :call)
      node.message.to_s.should == "name"
    end

    it "should get the message of binary" do
      node = parse_content("user.name == 'test'").find_node(:sexp_type => :binary)
      node.message.to_s.should == "=="
    end

    it "should get the message of fcall" do
      node = parse_content("test?('world')").find_node(:sexp_type => :fcall)
      node.message.to_s.should == "test?"
    end

    it "should get the message of method_add_arg" do
      node = parse_content("Post.find(:all)").find_node(:sexp_type => :method_add_arg)
      node.message.to_s.should == "find"
    end

    it "should get the message of method_add_block" do
      node = parse_content("Post.save do; end").find_node(:sexp_type => :method_add_block)
      node.message.to_s.should == "save"
    end
  end

  describe "conditional_statement" do
    it "should get conditional statement of if" do
      node = parse_content("if true; end").find_node(:sexp_type => :if)
      node.conditional_statement.to_s.should == "true"
    end

    it "should get conditional statement of unless" do
      node = parse_content("unless true; end").find_node(:sexp_type => :unless)
      node.conditional_statement.to_s.should == "true"
    end

    it "should get conditional statement of elsif" do
      content =<<-EOF
      if true
      elsif false
      end
      EOF
      node = parse_content(content).find_node(:sexp_type => :elsif)
      node.conditional_statement.to_s.should == "false"
    end

    it "should get conditional statement of ifop" do
      content =<<-EOF
      user ? user.name : nil
      EOF
      node = parse_content(content).find_node(:sexp_type => :ifop)
      node.conditional_statement.to_s.should == "user"
    end
  end

  describe "all_conditions" do
    it "should get all conditions" do
      node = parse_content("user == current_user && user.valid? || user.admin?").find_node(:sexp_type => :binary)
      node.all_conditions.size.should == 3
    end
  end

  describe "method_name" do
    it "should get the method name of def" do
      node = parse_content("def show; end").find_node(:sexp_type => :def)
      node.method_name.to_s.should == "show"
    end

    it "should get the method name of defs" do
      node = parse_content("def self.find; end").find_node(:sexp_type => :defs)
      node.method_name.to_s.should == "find"
    end
  end

  describe "statements" do
    it "should get statements of do_block node" do
      node = parse_content("resources :posts do; resources :comments; resources :like; end").find_node(:sexp_type => :do_block)
      node.statements.size.should == 2
    end

    it "should get statements of bodystmt node" do
      node = parse_content("class User; def login?; end; def admin?; end; end").find_node(:sexp_type => :bodystmt)
      node.statements.size.should == 2
    end
  end

  describe "hash_size" do
    it "should get value for hash node" do
      node = parse_content("{first_name: 'Richard', last_name: 'Huang'}").find_node(:sexp_type => :hash)
      node.hash_size.should == 2
    end

    it "should get value for bare_assoc_hash" do
      node = parse_content("add_user :user, first_name: 'Richard', last_name: 'Huang'").find_node(:sexp_type => :bare_assoc_hash)
      node.hash_size.should == 2
    end
  end

  describe "array_size" do
    it "should get array size" do
      node = parse_content("['first_name', 'last_name']").find_node(:sexp_type => :array)
      node.array_size.should == 2
    end

    it "should get 0" do
      node = parse_content("[]").find_node(:sexp_type => :array)
      node.array_size.should == 0
    end
  end

  describe "alias" do
    context "method" do
      before do
        @node = parse_content("alias new old").find_node(:sexp_type => :alias)
      end

      it "should get old_method" do
        @node.old_method.to_s.should == "old"
      end

      it "should get new_method" do
        @node.new_method.to_s.should == "new"
      end
    end

    context "symbol" do
      before do
        @node = parse_content("alias :new :old").find_node(:sexp_type => :alias)
      end

      it "should get old_method" do
        @node.old_method.to_s.should == "old"
      end

      it "should get new_method" do
        @node.new_method.to_s.should == "new"
      end
    end
  end

  describe "to_object" do
    it "should to array" do
      node = parse_content("['first_name', 'last_name']").find_node(:sexp_type => :array)
      node.to_object.should == ["first_name", "last_name"]
    end

    it "should to array with symbols" do
      node = parse_content("[:first_name, :last_name]").find_node(:sexp_type => :array)
      node.to_object.should == ["first_name", "last_name"]
    end

    it "should to empty array" do
      node = parse_content("[]").find_node(:sexp_type => :array)
      node.to_object.should == []
    end

    it "should to string" do
      node = parse_content("'richard'").find_node(:sexp_type => :string_literal)
      node.to_object.should == "richard"
    end
  end

  describe "to_s" do
    it "should get to_s for string" do
      node = parse_content("'user'").find_node(:sexp_type => :string_literal)
      node.to_s.should == "user"
    end

    it "should get to_s for symbol" do
      node = parse_content(":user").find_node(:sexp_type => :symbol_literal)
      node.to_s.should == "user"
    end

    it "should get to_s for const" do
      node = parse_content("User").find_node(:sexp_type => :@const)
      node.to_s.should == "User"
    end

    it "should get to_s for ivar" do
      node = parse_content("@user").find_node(:sexp_type => :@ivar)
      node.to_s.should == "@user"
    end

    it "should get to_s for class with module" do
      node = parse_content("ActiveRecord::Base").find_node(:sexp_type => :const_path_ref)
      node.to_s.should == "ActiveRecord::Base"
    end

    it "should get to_s for label" do
      node = parse_content("{first_name: 'Richard'}").find_node(:sexp_type => :@label)
      node.to_s.should == "first_name"
    end

    it "should get to_s for call" do
      node = parse_content("current_user.post").find_node(:sexp_type => :call)
      node.to_s.should == "current_user.post"
    end
  end

  describe "const?" do
    it "should return true for const with var_ref" do
      node = parse_content("User.find").find_node(:sexp_type => :var_ref)
      node.should be_const
    end

    it "should return true for const with @const" do
      node = parse_content("User.find").find_node(:sexp_type => :@const)
      node.should be_const
    end

    it "should return false for ivar" do
      node = parse_content("@user.find").find_node(:sexp_type => :@ivar)
      node.should_not be_const
    end
  end

  describe "present?" do
    it "should return true" do
      node = parse_content("hello world")
      node.should be_present
    end
  end

  describe "blank?" do
    it "should return false" do
      node = parse_content("hello world")
      node.should_not be_blank
    end
  end

  describe "remove_line_and_column" do
    it "should remove" do
      s(:@ident, "test", s(2, 12)).remove_line_and_column.should_equal s(:@ident, "test")
    end

    it "should remove child nodes" do
      s(:const_ref, s(:@const, "Demo", s(1, 12))).remove_line_and_column.should_equal s(:const_def, s(:@const, "Demo"))
    end
  end
=end
end
