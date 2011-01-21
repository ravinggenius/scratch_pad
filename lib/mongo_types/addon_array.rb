class AddonArray < Array
  def self.to_mongo(values)
    (values || []).map { |v| v.respond_to?(:machine_name) ? v.machine_name : v }
  end

  def self.from_mongo(values)
    (values || []).map do |v|
      klass = name.sub 'Array', ''
      v.respond_to?(:machine_name) ? v : "ScratchPad::Addon::#{klass}".constantize[v]
    end
  end
end
