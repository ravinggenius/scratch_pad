require 'dm-is-list'
require 'dm-is-nested_set'
require 'dm-timestamps'

class Node
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :required => true
  property :type_id, Integer, :required => true
  property :type_name, String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :user
  has n, :vocabularies, :through => Resource
  has n, :terms, :through => Resource

  is :list

  def extension
    @extension ||= Kernel.const_get(type_name).get(type_id)
  end

  def machine_name
    type_name.underscore
  end
end
