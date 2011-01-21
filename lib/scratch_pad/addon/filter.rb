module ScratchPad::Addon
  class Filter < Base
    def self.process_all(input, filter_group)
      filter_group.filters.each do |filter|
        input = filter.process input
      end
      input
    end
  end
end
