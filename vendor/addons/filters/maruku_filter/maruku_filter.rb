module Filters
  class MarukuFilter < ScratchPad::Addon::Filter
    def self.process(string)
      Maruku.new(string).to_html
    end
  end
end
