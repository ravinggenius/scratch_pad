# remove all children in case an asset was updated since our last deploy
(Rails.root + 'tmp' + 'assets').children.each do |child|
  next if child.basename.to_s.starts_with? '.'
  FileUtils.rm_r child
end
