addons = Gem.loaded_specs.keys.map { |g| g.scan /^scratch_pad-(.*)/; $1 }.compact.each do |addon|
  scope, name = addon.split '-'
  require "scratch_pad-#{scope}-#{name}/#{name}"
end
