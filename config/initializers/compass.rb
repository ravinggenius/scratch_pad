require 'compass'
# If you have any compass plugins, require them here.
Compass.configuration.parse(File.join(RAILS_ROOT, "config", "compass.config"))
Compass.configuration.environment = RAILS_ENV.to_sym
Sass::Plugin.options[:never_update] = true if Rails.env == 'production'
Compass.configure_sass_plugin!
