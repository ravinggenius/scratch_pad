class Node
  class OwnGrandfatherException < StandardError
    def initialize(node_id = nil)
      @node_id = node_id
      super
    end

    def message
      reply = 'node added as a descendant of itself'
      reply << " (#{@node_id})" if @node_id
      reply
    end
  end
end
