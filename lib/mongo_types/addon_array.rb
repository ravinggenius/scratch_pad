class AddonArray < Array
  def self.to_mongo(values)
    values ||= []
    values.map { |v| v.respond_to?(:machine_name) ? v.machine_name : v }
  end

  def self.from_mongo(values)
    values ||= []
    values.map { |v| v.respond_to?(:machine_name) ? v : AddonBase[v] }
  end
end
