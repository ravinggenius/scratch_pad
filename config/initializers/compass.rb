require 'compass'

Compass.add_project_configuration(File.join(Rails.root.to_s, 'config', 'compass.rb'))
Sass::Plugin.options[:never_update] = true if Rails.env == 'production'
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
