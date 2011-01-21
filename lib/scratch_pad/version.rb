module ScratchPad
  class Version
    attr_accessible :major, :minor, :patch

    def to_s
      [major, minor, patch].join '.'
    end
  end
end
