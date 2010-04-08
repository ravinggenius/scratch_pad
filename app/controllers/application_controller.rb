class ApplicationController < ActionController::Base
  protect_from_forgery
  append_view_path 'lib/node_extensions'

  before_filter do
    @title = 'ScratchPad'
    @site_name = 'ScratchPad'
    @site_tagline = ''
  end
end
