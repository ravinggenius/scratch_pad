require 'dm-types'

class Blob < DataMapper::Type
  #primitive Text
  primitive String

  def self.dump value, property
  end

  def self.load value, property
  end

  #def self.typecast value, property
  #end
end
