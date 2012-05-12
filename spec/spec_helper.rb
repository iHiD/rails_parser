require File.join(File.dirname(__FILE__), "..", "lib", "rails_auditor")

def default_application_path
  @default_app_path ||= File.join(File.dirname(__FILE__), "default_app")
end