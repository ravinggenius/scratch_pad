source :rubygems

v = {
  :dm => '~> 0.10.2',
  :do => '~> 0.10.1'
}

gem 'data_objects',          v[:do]
gem 'do_postgres',           v[:do], :group => :production
gem 'do_sqlite3',            v[:do], :group => :development

gem 'dm-aggregates',         v[:dm]
gem 'dm-constraints',        v[:dm]
gem 'dm-core',               v[:dm]
gem 'dm-migrations',         v[:dm]
gem 'dm-observer',           v[:dm]
gem 'dm-rails',              v[:dm], :git => 'git://github.com/datamapper/dm-rails.git'
gem 'dm-timestamps',         v[:dm]
gem 'dm-transactions',       v[:dm], :git => 'git://github.com/datamapper/dm-transactions.git'
gem 'dm-types',              v[:dm]
gem 'dm-validations',        v[:dm]

gem 'dm-is-list',            v[:dm]
gem 'dm-is-nested_set',      v[:dm]

gem 'bcrypt-ruby',           '~> 2.1.2' , :require => 'bcrypt'
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
