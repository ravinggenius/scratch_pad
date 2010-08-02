NodeExtension.all.each do |ne|
  require "#{ne.path}/models/#{ne.name}.rb"
end
