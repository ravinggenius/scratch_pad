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
      regions = layout.delete(:regions).map { |region_name| LayoutRegion.new(:name => region_name) }
      Layout.first_or_new(layout).update_attributes(:regions => regions)
    end
    ms
  end

  def self.disable
    ms = message_scope
    Layout.all(:scope => ms).each &:delete
    super
  end

  def self.register_layout(name, *regions)
    ms = message_scope
    @layouts ||= {}
    @layouts[ms] ||= []
    (regions + default_regions).each(&:to_s).uniq!
    @layouts[ms] << { :theme => machine_name, :name => name, :regions => regions }
  end

  private

  def self.default_regions
    %w[ head_start head_end body_start body_end ]
  end
end
