class Table
  include DataMapper::Resource
  include NodeExtension

  property :id, Serial
  property :caption, String, :required => true
  property :data, Csv, :required => true, :lazy => false
  property :has_header_row, Boolean, :required => true, :default => true

  after :save, :set_id
end
