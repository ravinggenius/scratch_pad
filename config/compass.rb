require 'susy'

project_type = :rails
project_path = Rails.root
environment = Compass::AppIntegration::Rails.env
output_style = :compact
relative_assets = false

# Set this to the root of your project when deployed:
http_path = '/'
sass_dir = 'app/stylesheets'
css_dir = 'tmp/stylesheets'
images_dir = 'public/images'
javascripts_dir = 'public/javascripts'
http_stylesheets_path = '/stylesheets'
http_images_path = '/images'
http_javascripts_path = '/javascripts'
