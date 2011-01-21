base = Rails.root + 'vendor' + 'addons'

Dir[base + '**' + '*.rb'].each do |name|
  name =~ /^#{Regexp.escape(base.to_s)}\/(.*)\.rb$/
  require base + $1
end
