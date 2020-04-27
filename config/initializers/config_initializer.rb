require 'ostruct'
require 'yaml'

_config = YAML.load_file(Rails.root.join("config/config.yml"))[Rails.env] || YAML.load_file(Rails.root.join("config/config.yml.example"))[Rails.env]
ADDITIONAL_CONFIG = OpenStruct.new(_config)
