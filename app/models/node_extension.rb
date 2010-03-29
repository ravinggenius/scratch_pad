module NodeExtension
  def node
    @node ||= Node.first node_params
    @node ||= Node.new node_params
  end

  def method_missing missing_method, *args
    if node.respond_to? missing_method
      node.send missing_method, *args
    else
      super
    end
  end

  private

  def node_params
    { :type_id => self.id, :type_name => self.class.name }
  end

  def set_id
    node.type_id = self.id
    node.save
  end
end
