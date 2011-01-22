module Themes
  class Default < ScratchPad::Addon::Theme
    register_font 'zenda', 'Zenda-fontfacekit', 'Paul Lloyd License Agreement.txt' do |font|
      font.add_file 'zenda-webfont.eot'
      font.add_file 'zenda-webfont.svg'
      font.add_file 'zenda-webfont.ttf'
      font.add_file 'zenda-webfont.woff'
    end

    register_layout :single_column, :is_default => true do |regions|
      regions << register_region(:branding, :header)
      regions << register_region(:main_menu, :nav)
      regions << register_region(:flash, :section)
      regions << register_region(:content, :section)
      regions << register_region(:credits, :footer)
    end
  end
end
