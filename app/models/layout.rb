class Layout
  include MongoMapper::Document

  key :theme, String, :required => true
  key :name, String, :required => true
  key :is_default, Boolean, :default => false

  many :regions, :class_name => 'LayoutRegion'

  def region(region_name)
    region_name = region_name.to_sym
    regions.detect { |r| r.name.to_sym == region_name }
  end

  def custom_regions
    regions.reject { |r| ScratchPad::Addon::Theme.default_regions.include? r.name }
  end

  def to_param
    name
  end
end
