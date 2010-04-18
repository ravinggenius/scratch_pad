source :rubygems

v = {
  :datamapper => '~> 0.10.2',
  :data_objects => '~> 0.10.1'
}

gem 'data_objects',          v[:data_objects]
gem 'do_postgres',           v[:data_objects], :group => :production
gem 'do_sqlite3',            v[:data_objects], :group => :development

gem 'dm-aggregates',         v[:datamapper]
gem 'dm-constraints',        v[:datamapper]
gem 'dm-core',               v[:datamapper]
gem 'dm-migrations',         v[:datamapper]
gem 'dm-observer',           v[:datamapper]
gem 'dm-rails',              v[:datamapper], :git => 'git://github.com/datamapper/dm-rails.git'
gem 'dm-timestamps',         v[:datamapper]
gem 'dm-transactions',       v[:datamapper], :git => 'git://github.com/datamapper/dm-transactions.git'
gem 'dm-types',              v[:datamapper]
gem 'dm-validations',        v[:datamapper]

gem 'dm-is-list',            v[:datamapper]
gem 'dm-is-nested_set',      v[:datamapper]

gem 'compass',               '~> 0.10.0.rc1'
gem 'compass-jquery-plugin', '~> 0.2.5'
gem 'compass-susy-plugin',   '~> 0.6.3'
gem 'haml',                  '~> 3.0.0.beta'
gem 'maruku',                '~> 0.6.0'
gem 'rails',                 '~> 3.0.0.beta3'
#gem 'unicorn'

group :development do
  gem 'awesome_print'
  gem 'hirb'
  gem 'ruby-debug'
end

group :production do
  gem 'thin'
  gem 'pg'
end
