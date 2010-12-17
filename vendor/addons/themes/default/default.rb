class Default < Theme
  register_layout :single_column, :is_default => true do |regions|
    regions << register_region(:branding, :header)
    regions << register_region(:flash, :section)
    regions << register_region(:content, :section)
    regions << register_region(:credits, :footer)
  end

  register_layout :two_column do |regions|
    regions << register_region(:branding, :header)
    regions << register_region(:flash, :section)
    regions << register_region(:content, :section)
    regions << register_region(:credits, :footer)
  end
end
