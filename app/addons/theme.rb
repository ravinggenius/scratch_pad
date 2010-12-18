class Theme < AddonBase
  def self.admin?
    machine_name.end_with? '_admin'
  end

  def self.frontend
    enabled.reject { |theme| theme.admin? }
  end

  def self.backend
    enabled.select { |theme| theme.admin? }
  end

  def self.frontend?
    Theme.frontend.include? self
  end

  def self.backend?
    Theme.backend.include? self
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
