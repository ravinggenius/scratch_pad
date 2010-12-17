class DefaultAdmin < Theme
  register_layout :single_column do |regions|
    regions << register_region(:branding, :header)
    regions << register_region(:navigation)
    regions << register_region(:flash, :section)
    regions << register_region(:content, :section)
  end
end
