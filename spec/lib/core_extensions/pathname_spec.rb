require 'spec_helper'

describe Pathname do
  describe '#extensionless' do
    it 'should return a Pathname without an extension' do
      (Rails.root + 'config.ru').extensionless.should == (Rails.root + 'config')
      (Rails.root + 'config.ru').extensionless.to_s.should == "#{Rails.root}/config"
    end

    it 'should not do anything when given a directory' do
      (Rails.root + 'app').extensionless.should == (Rails.root + 'app')
      (Rails.root + 'app').extensionless.to_s.should == "#{Rails.root}/app"
    end
  end
end
