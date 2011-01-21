module Widgets
  class GoogleAnalytics < ScratchPad::Addon::Widget
    register_setting :account_code, 'Account Code', 'UA-xxxxxxx-xx'
  end
end
