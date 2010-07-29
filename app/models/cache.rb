class Cache
  include MongoMapper::Document

  key :key, String, :required => true
  key :value, String, :required => true

  timestamps!

  def expired?
    value.nil? || ((c.updated_at + 1.day) < Time.now)
  end

  def self.[](index)
    @loaded ||= {}
    @loaded[index] ||= Cache.first_or_new(:key => index)
  end
end
