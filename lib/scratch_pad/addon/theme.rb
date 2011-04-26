module ScratchPad::Addon
  class Theme < Base
    def self.admin?
      deprecate! :admin?, :backend?
      backend?
    end

    def self.frontend
      enabled.select { |theme| theme.frontend? }
    end

    def self.backend
      enabled.select { |theme| theme.backend? }
    end

    def self.frontend?
      !backend?
    end

    def self.backend?
      %w[ _admin _backend ].any? { |stub| machine_name.end_with? stub }
    end

    def self.static_asset_types
      super << 'fonts'
    end

    def self.fonts_path
      public_path + 'fonts'
    end

    def self.fonts
      (@fonts || {})[message_scope] || []
    end

    def self.favicon
      ms = message_scope
      (@favicons || {})[ms]
    end

    def self.favicon?
      ms = message_scope
      (@favicons || {}).key? ms
    end

    def self.register_favicon(path)
      ms = message_scope
      @favicons ||= {}
      @favicons[ms] = path
    end

    def self.default_layout
      Layout.first(:theme => machine_name, :is_default => true) or Layout.first(:theme => machine_name)
    end

    def self.layout(name = nil)
      Layout.first(:theme => machine_name, :name => name) or default_layout
    end

    def self.layouts
      Layout.all :theme => machine_name
    end

    def self.enable
      ms = super
      @layouts ||= {}
      (@layouts[ms] || []).each do |layout|
        regions = layout.delete(:regions).map { |region| LayoutRegion.new region }
        Layout.first_or_new(:theme => layout[:theme], :name => layout[:name]).update_attributes(layout.merge(:regions => regions))
      end
      ms
    end

    def self.disable
      ms = message_scope
      Layout.all(:scope => ms).each &:delete
      super
    end

    def self.register_font(use_name, base_path, license = nil, &block)
      ms = message_scope
      @fonts ||= {}
      @fonts[ms] ||= []
      @fonts[ms] << ScratchPad::Font.new(use_name, base_path, license, &block)
    end

    def self.register_layout(name, options = {}, &regions_block)
      ms = message_scope
      @layouts ||= {}
      @layouts[ms] ||= []

      regions = []
      default_regions.each { |region_name| regions << register_region(region_name) }
      regions_block.call regions

      @layouts[ms] << options.merge({
        :theme => machine_name,
        :name => name,
        :regions => regions
      })
    end

    def self.register_region(name, wrapper = nil)
      { :name => name, :wrapper => wrapper }
    end

    def self.default_regions
      %w[ head_alpha head_omega body_alpha body_omega ]
    end
  end
end
