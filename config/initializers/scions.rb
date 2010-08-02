NodeExtension['*'].each do |entry|
  require "#{entry}/models/#{File.basename(entry)}"
end
