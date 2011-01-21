module Filters
  class DoNothing < ScratchPad::Addon::Filter
    def self.process(string)
      string
    end
  end
end
