module ScratchPad
  class StaticAssets
    ASSET_ROOT = Rails.root + 'tmp' + 'assets'

    # cache files so they get served with Rack::Static on the next request
    def self.create(name, content)
      full_path = (ASSET_ROOT + name).expand_path

      if full_path.to_path.starts_with? ASSET_ROOT.to_path
        full_path.dirname.mkpath
        full_path.open('w') { |f| f.write content }

        Rails.logger.info "CACHED #{full_path}"
      end
    end

    def self.delete_all
      ASSET_ROOT.children.each do |child|
        next if child.basename.to_s.starts_with? '.'
        FileUtils.rm_r child
      end if ASSET_ROOT.directory?
    end
  end
end
