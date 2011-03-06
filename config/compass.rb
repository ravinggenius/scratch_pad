project_type = :rails
project_path = Compass::AppIntegration::Rails.root
environment = Compass::AppIntegration::Rails.env

output_style = (Rails.env.production? ? :compressed : :expanded)
preferred_syntax = :sass
relative_assets = false

http_path = '/'

sass_dir = 'app/stylesheets'
css_dir = 'tmp/stylesheets'