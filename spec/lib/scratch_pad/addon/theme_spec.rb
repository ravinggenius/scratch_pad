require 'spec_helper'

describe ScratchPad::Addon::Theme do
  let(:frontend_theme) { ScratchPad::Addon::Theme[:default] }
  let(:backend_theme) { ScratchPad::Addon::Theme[:default_admin] }

  describe '.admin?' do
    it 'has been depricated'
  end

  describe '.frontend' do
    it ''
  end

  describe '.backend' do
    it ''
  end

  describe '.frontend?' do
    specify { frontend_theme.should be_frontend }
    specify { frontend_theme.should_not be_backend }
  end

  describe '.backend?' do
    specify { backend_theme.should be_backend }
    specify { backend_theme.should_not be_frontend }
  end

  describe '.static_asset_types' do
    it 'returns list of generic asset types that ScratchPad is aware of, in addition to extra types that Themes are aware of'
  end

  describe '.fonts_path' do
    it 'returns the absolute or relative path to the addon\'s font directory'
  end

  describe '.fonts' do
    it 'returns a list of fonts that the addon utilizes'
  end

  describe '.default_layout' do
    it 'retrieves the default layout or the first layout if a default was not specified'
  end

  describe '.layout' do
    it 'retrieves the named layout or the default layout if none was found'
  end

  describe '.layouts' do
    it 'retrieves all layouts registered by the theme'
  end

  describe '.enable!' do
    it ''
  end

  describe '.disable!' do
    it ''
  end

  describe '.register_font' do
    it 'allows a theme to reference a custom font in its stylesheet'
  end

  describe '.register_layout' do
    it ''
  end

  describe '.register_region' do
    it 'adds a region to a layout'
  end

  describe '.default_regions' do
    it 'returns a list of ScratchPad declared regions which will always be available' do
      ScratchPad::Addon::Theme.default_regions.should eql(%w[ head_alpha head_omega body_alpha body_omega ])
    end
  end
end
