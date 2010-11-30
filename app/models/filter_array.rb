class FilterArray < Array
  def self.to_mongo(values)
    values ||= []
    values.map { |v| v.respond_to?(:machine_name) ? v.machine_name : v }
  end

  def self.from_mongo(values)
    values ||= []
    values.map { |v| v.respond_to?(:machine_name) ? v : Filter[v] }
  end
end
