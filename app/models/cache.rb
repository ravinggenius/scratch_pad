class Cache
  include MongoMapper::Document

  key :key, String, :required => true
  key :value, String, :required => true

  timestamps!

  def self.[](index)
    @loaded ||= {}
    @loaded[index] ||= Cache.first_or_new(:key => index)
  end
end
