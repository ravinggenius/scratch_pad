module ScratchPad
  class StaticAssets
    def self.expire_all
      asset_dir = Rails.root + 'tmp' + 'assets'
      asset_dir.children.each do |child|
        next if child.basename.to_s.starts_with? '.'
        FileUtils.rm_r child
      end if asset_dir.directory?
    end
  end
end
