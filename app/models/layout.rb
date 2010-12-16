class Layout
  include MongoMapper::Document

  key :theme, String, :required => true
  key :name, String, :required => true
  key :is_default, Boolean, :required => true, :default => false

  many :regions, :class_name => 'LayoutRegion'

  def regions_hash
    reply = Hash.new []
    regions.each do |region|
      reply[region.name.to_sym] = region.widgets if region.widgets.any?
    end
    reply
  end
end
