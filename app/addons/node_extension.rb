class NodeExtension < AddonBase
  class Model < Node
    def self.title
      name.scan /^(.*)::Model$/
      $1
    end
  end
end
