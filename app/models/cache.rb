class Cache
  include MongoMapper::Document

  KEY_GLUE = '.'

  key :key, String, :required => true
  key :value, String, :required => true

  timestamps!

  def expired?
    value.nil? || ((updated_at + 1.day) < Time.now)
  end

  def self.[](*key)
    key = key.join KEY_GLUE
    @loaded ||= {}
    @loaded[key] ||= Cache.first_or_new(:key => key)
  end

  def self.expire_all
    delete_all
    @loaded = {}
  end
end
