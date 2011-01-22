module ScratchPad
  class Version
    attr_accessor :major, :minor, :patch

    def to_s
      [major, minor, patch].join '.'
    end
  end
end
