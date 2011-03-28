project_type = :rails
project_path = Compass::AppIntegration::Rails.root
environment = Compass::AppIntegration::Rails.env

# support for FireSASS
# TODO find out why this doesn't seem to work
sass_options = { :debug_info => true }

output_style = (Rails.env.production? ? :compressed : :expanded)
preferred_syntax = :sass
relative_assets = false

http_path = '/'

sass_dir = 'app/stylesheets'
css_dir = 'tmp/stylesheets'