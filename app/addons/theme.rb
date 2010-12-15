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

  def self.register_layout(name, *regions)
    ms = message_scope
    @layouts ||= {}
    @layouts[ms] ||= []
    regions << :head << :tail
    @layouts[ms] << { :name => name, :regions => regions.each(&:to_s).uniq }
  end

  def self.enable
    ms = super
    @layouts ||= {}
    (@layouts[ms] || []).each do |layout|
      regions = layout.delete(:regions).map { |region_name| { :name => region_name } }
      Layout.first_or_new(layout.merge(:scope => ms)).update_attributes(:regions => regions)
    end
    ms
  end

  def self.disable
    ms = message_scope
    Layout.all(:scope => ms).each &:delete
    super
  end
end
