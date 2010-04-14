class List
  include DataMapper::Resource
  include NodeExtension

  GLUE = "\n"

  property :id, Serial
  property :data, Text, :required => true, :lazy => false, :accessor => :protected

  before :save do
    @items ||= []
    self.data = @items.join GLUE
  end

  after :save, :set_id

  def items
    self.data ||= ''
    @items ||= self.data.split GLUE
  end

  def items= list
    @items = list
  end
end
