source :rubygems

do_version = '~> 0.10.1'
dm_version = '~> 0.10.3'

gem 'rails',                 '~> 3.0.0.beta3'

gem 'data_objects',          do_version
gem 'do_postgres',           do_version, :group => :production
gem 'do_sqlite3',            do_version, :group => :development

gem 'dm-core',               dm_version, :git => 'git://github.com/datamapper/dm-core.git'
gem 'dm-rails',              '~> 0.10.2', :git => 'git://github.com/datamapper/dm-rails.git'
gem 'dm-transactions',       dm_version, :git => 'git://github.com/datamapper/dm-transactions.git'

git 'git://github.com/datamapper/dm-more.git' do
  gem 'dm-types',            dm_version
  gem 'dm-validations',      dm_version
  gem 'dm-constraints',      dm_version
  gem 'dm-aggregates',       dm_version
  gem 'dm-timestamps',       dm_version
  gem 'dm-migrations',       dm_version
  gem 'dm-observer',         dm_version
  gem 'dm-is-list',          dm_version
  gem 'dm-is-nested_set',    dm_version
end

gem 'haml',                  '~> 3.0.0.beta'
gem 'compass',               '~> 0.10.0.rc1'
gem 'compass-susy-plugin',   '~> 0.6.3'
gem 'compass-jquery-plugin', '~> 0.2.5'
gem 'maruku',                '~> 0.6.0'
#gem 'unicorn'

group :development do
  gem 'ruby-debug'
  gem 'hirb'
  gem 'awesome_print'
end

group :production do
  gem 'thin'
  gem 'pg'
end
