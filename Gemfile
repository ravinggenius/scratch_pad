source 'http://gemcutter.org'

rails_version = '~> 3.0.0.beta2'
do_version = '~> 0.10.1'
dm_version = '~> 0.10.2'

git 'git://github.com/rails/rails.git'

gem 'activesupport',     rails_version, :require => 'active_support'
gem 'actionpack',        rails_version, :require => 'action_pack'
gem 'railties',          rails_version, :require => 'rails'
gem 'actionmailer',      rails_version, :require => 'action_mailer'

gem 'data_objects',      do_version
gem 'do_sqlite3',        do_version

# You can use any of the other available database adapters.
# This is only a small excerpt of the list of all available adapters
# Have a look at
#
#  http://wiki.github.com/datamapper/dm-core/adapters
#  http://wiki.github.com/datamapper/dm-core/community-plugins
#
# for a rather complete list of available datamapper adapters and plugins

# gem 'do_mysql',          do_version
# gem 'do_postgres',       do_version
# gem 'do_oracle',         do_version

gem 'dm-core',             dm_version, :git => 'git://github.com/datamapper/dm-core.git'

git 'git://github.com/datamapper/dm-more.git' do
  gem 'dm-types',          dm_version
  gem 'dm-validations',    dm_version
  gem 'dm-constraints',    dm_version
  gem 'dm-aggregates',     dm_version
  gem 'dm-timestamps',     dm_version
  gem 'dm-migrations',     dm_version
  gem 'dm-observer',       dm_version
  gem 'dm-is-list',        dm_version
  gem 'dm-is-nested_set',  dm_version
end

git 'git://github.com/datamapper/dm-rails.git'

gem 'dm-rails', dm_version

gem 'haml', '~> 2.2.22'
gem 'compass', '~> 0.10.0.rc1'
gem 'compass-susy-plugin', '~> 0.6.3'
gem 'compass-jquery-plugin', '~> 0.2.5'

group(:development) do
  gem 'hirb'
end
