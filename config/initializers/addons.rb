# activate gem addons (preferred method)
addons = Gem.loaded_specs.keys.map { |g| g.scan /^scratch_pad-(.*)/; $1 }.compact.each do |addon|
  scope, name = addon.split '-'
  require "scratch_pad-#{scope}-#{name}/#{name}"
end

# activate old-style addons
base = Rails.root + 'vendor' + 'addons'
Dir[base + '**' + '*.rb'].each do |name|
  name =~ /^#{Regexp.escape(base.to_s)}\/(.*)\.rb$/
  require base + $1
end
