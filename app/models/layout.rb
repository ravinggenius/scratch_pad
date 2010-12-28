class Layout
  include MongoMapper::Document

  key :theme, String, :required => true
  key :name, String, :required => true
  key :is_default, Boolean, :required => true, :default => false

  many :regions, :class_name => 'LayoutRegion'

  def region(region_name)
    region_name = region_name.to_sym
    # FIXME find a better way to do this
    regions.select { |r| r.name.to_sym == region_name }.first
  end

  def custom_regions
    regions.reject { |r| Theme.default_regions.include? r.name }
  end
end
