class Filter < ScionBase
  def name
    super.gsub /\.rb/, ''
  end

  def filter
    @filter ||= name.camelize.constantize
  end

  def self.process_all(input, filter_group)
    filter_group.filters.each do |f|
      input = from_mongo(f).filter.process input
    end
    input
  end

  def self.to_mongo(value)
    if value.respond_to? :name
      value.name
    else
      value
    end
  end

  def self.from_mongo(value)
    if value.respond_to? :name
      value
    else
      Filter["#{value}.rb"]
    end
  end
end
