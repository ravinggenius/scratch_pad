require 'spec_helper'

describe SessionsController do
  describe 'index' do
  end

  describe 'create' do
    describe 'when logging in with username/password' do
      context 'and valid credentials' do
        it ''
      end

      context 'and invalid credentials' do
        it ''
      end
    end

    it 'should be successful' do
      get 'create'
      response.should be_success
    end
  end

  describe 'destroy' do
  end
end
