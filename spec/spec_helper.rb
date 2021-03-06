require File.join(File.dirname(__FILE__), "..", "lib", "rails_parser")
require 'awesome_print'
require 'tempfile'

def default_application_path
  @default_app_path ||= File.join(File.dirname(__FILE__), "apps/3_2_3_default")
end

def create_tempfile(content)
  file = Tempfile.new("test")
  file.write(content)
  file.close
  return file
end