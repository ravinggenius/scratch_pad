project_type = :rails
project_path = Compass::AppIntegration::Rails.root
environment = Compass::AppIntegration::Rails.env

# support for FireSASS
# TODO find out why this doesn't seem to work
sass_options = { :debug_info => !Rails.env.production? }

# some styles fail to be applied with :compressed output
output_style = (Rails.env.production? ? :compact : :expanded)
preferred_syntax = :sass
relative_assets = false

http_path = '/'

sass_dir = 'app/stylesheets'
css_dir = 'tmp/stylesheets'
