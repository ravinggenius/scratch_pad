Dir[Rails.root + 'lib' + 'node_extensions' + '*'].each do |entry|
  require "#{entry}/models/#{File.basename(entry)}"
end
