require 'susy'

project_type = :rails
environment = Compass::AppIntegration::Rails.env
output_style = :compact
relative_assets = false

sass_dir = 'app/stylesheets'
css_dir = 'tmp/stylesheets'
images_dir = 'public/images'
javascripts_dir = 'public/javascripts'

add_import_path 'vendor/addons'

http_path = '/'
