module Gotsha
  module Config
    CONFIG_DIR = ".gotsha"
    CONFIG_FILE = File.join(CONFIG_DIR, "config.yml")
    CONFIG_TEMPLATE_PATH = "lib/gotsha/templates/config.yml"
    GH_CONFIG_FILE = File.join(CONFIG_DIR, "github_action_example.yml")
    GH_CONFIG_TEMPLATE_PATH = "lib/gotsha/templates/github_action_example.yml"
    HOOKS_TEMPLATES_DIR = "lib/gotsha/templates"
    HOOKS_DIR = File.join(CONFIG_DIR, "hooks")
  end
end
