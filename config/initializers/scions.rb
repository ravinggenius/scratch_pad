Dir[Rails.root + 'scions' + 'node_extensions' + '*'].each do |entry|
  require "#{entry}/models/#{File.basename(entry)}"
end
