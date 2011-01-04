base = Rails.root + 'lib' + 'core_extensions'

Dir[base + '**' + '*.rb'].each do |name|
  name =~ /^#{Regexp.escape(base.to_s)}\/(.*)\.rb$/
  require base + $1
end
