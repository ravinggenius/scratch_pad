module Widgets
  class Copyright < ScratchPad::Addon::Widget
    register_setting :phrase, 'Copyright Notice', '&#169; %{site_name}'
  end
end
