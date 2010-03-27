source 'http://gemcutter.org'

git 'git://github.com/rails/rails.git'

gem 'activesupport',     '~> 3.0.0.beta1', :require => 'active_support'
gem 'actionpack',        '~> 3.0.0.beta1', :require => 'action_pack'
gem 'railties',          '~> 3.0.0.beta1', :require => 'rails'

# Uncomment this if you need actionmailer
# gem 'actionmailer',      '~> 3.0.0.beta1', :require => 'action_mailer'

gem 'data_objects',      '~> 0.10.1'
gem 'do_sqlite3',        '~> 0.10.1'

# You can use any of the other available database adapters.
# This is only a small excerpt of the list of all available adapters
# Have a look at
#
#  http://wiki.github.com/datamapper/dm-core/adapters
#  http://wiki.github.com/datamapper/dm-core/community-plugins
#
# for a rather complete list of available datamapper adapters and plugins

# gem 'do_mysql',          '~> 0.10.1'
# gem 'do_postgres',       '~> 0.10.1'
# gem 'do_oracle',         '~> 0.10.1'

gem 'dm-core',             '~> 0.10.2', :git => 'git://github.com/datamapper/dm-core.git'

git "git://github.com/datamapper/dm-more.git" do
  gem 'dm-types',          '~> 0.10.2'
  gem 'dm-validations',    '~> 0.10.2'
  gem 'dm-constraints',    '~> 0.10.2'
  gem 'dm-aggregates',     '~> 0.10.2'
  gem 'dm-timestamps',     '~> 0.10.2'
  gem 'dm-migrations',     '~> 0.10.2'
  gem 'dm-observer',       '~> 0.10.2'
end

git 'git://github.com/datamapper/dm-rails.git'

gem 'dm-rails', '~> 0.10.2'

gem 'haml', '~> 2.2.22'
gem 'compass', '~> 0.8.17'
gem 'compass-susy-plugin', '~> 0.6.3'
gem 'compass-jquery-plugin', '~> 0.2.5'

git 'git://github.com/rspec/rspec.git'
git 'git://github.com/rspec/rspec-core.git'
git 'git://github.com/rspec/rspec-expectations.git'
git 'git://github.com/rspec/rspec-mocks.git'
git 'git://github.com/rspec/rspec-rails.git'

group(:test) do
  gem 'rspec',              '2.0.0.beta.4'
  gem 'rspec-core',         '2.0.0.beta.4', :require => 'rspec/core'
  gem 'rspec-expectations', '2.0.0.beta.4', :require => 'rspec/expectations'
  gem 'rspec-mocks',        '2.0.0.beta.4', :require => 'rspec/mocks'
  gem 'rspec-rails',        '2.0.0.beta.4'
end
