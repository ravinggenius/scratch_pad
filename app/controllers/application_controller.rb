class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    @title = 'ScratchPad'
    @site_name = 'ScratchPad'
    @site_tagline = ''
  end
end
