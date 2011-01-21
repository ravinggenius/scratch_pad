class AddonConfiguration
  include MongoMapper::Document

  key :name, String, :required => true

  before_save do |config|
    config.errors.add 'AddonConfiguration is abstract.' if config.class == AddonConfiguration
  end
end
