# config/initializers/load_ldap_config.rb
LDAP_CONFIG = YAML::load(ERB.new(File.read(Rails.root.join('config', 'ldap.yml'))).result)[Rails.env].symbolize_keys
