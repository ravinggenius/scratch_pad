require 'susy'

project_type = :rails
project_path = Rails.root
environment = Compass::AppIntegration::Rails.env
output_style = :compact
relative_assets = false

sass_dir = 'app/stylesheets'
css_dir = 'tmp/stylesheets'
images_dir = 'public/images'
javascripts_dir = 'public/javascripts'

add_import_path 'lib'

http_path = '/'
http_stylesheets_path = '/assets/stylesheets'
http_images_path = '/assets/images'
http_javascripts_path = '/assets/javascripts'
