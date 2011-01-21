class Cache
  include MongoMapper::Document

  KEY_GLUE = '.'

  key :key, String, :required => true
  key :value, String, :required => true

  timestamps!

  before_save do |cache|
    Rails.logger.info "Rebuilding CACHE[#{cache.key}]"
  end

  # NOTE MongoMapper implements #valid?
  def expired?
    value.nil? || ((updated_at + 1.day) < Time.now)
  end

  def self.[](*key)
    key = key.join KEY_GLUE
    Rails.logger.info "Reading from CACHE[#{key}]"
    @loaded ||= {}
    @loaded[key] ||= Cache.first_or_new(:key => key)
  end

  def self.expire_all
    delete_all
    @loaded = {}
    Rails.logger.info 'CACHE reset'
  end
end
