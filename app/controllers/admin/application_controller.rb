class Admin::ApplicationController < ApplicationController
  before_filter do
    authorize!
  end

  before_filter do
    set_theme_ivars :backend
  end
end
