require 'compass'

Compass.add_project_configuration((Rails.root + 'config' + 'compass.rb').to_s)
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
