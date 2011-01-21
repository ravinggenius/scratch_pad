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

    def self.fonts_path(relative = false)
      root(relative) + 'fonts'
    end

    def self.fonts
      reply = {}
      @fonts ||= {}
      (@fonts[message_scope] || {}).each do |font_name, font_files|
        reply[font_name] = {}
        font_files.each do |ext, file_name|
          reply[font_name][ext] = Pathname.new file_name
        end
      end
      reply
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

    def self.register_font(use_name, font_files = {})
      ms = message_scope
      @fonts ||= {}
      @fonts[ms] ||= {}
      @fonts[ms][use_name] = font_files
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
