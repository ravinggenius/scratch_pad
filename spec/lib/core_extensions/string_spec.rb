require 'spec_helper'

describe String do
  describe '#truthy?' do
    [
      '1',
      'ON',
      'T',
      'TRUE',
      'Y',
      'YES',
      'on',
      't',
      'true',
      'y',
      'yes'
    ].each do |value|
      it "should return true for #{value}" do
        value.truthy?.should be_true
      end
    end
  end
end
