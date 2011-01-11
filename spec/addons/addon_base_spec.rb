require 'spec_helper'

describe AddonBase do
  describe '.[]' do
    it 'loads the addon whose name is sent to it'
  end

  describe '.<=>' do
    it 'sorts addons by name'
  end

  describe '.static_asset_types' do
    it 'returns list of generic asset types that ScratchPad is aware of'
  end

  describe '.root' do
    it 'returns the absolute or relative path to the addon directory'
  end

  describe '.images_path' do
    it 'returns the absolute or relative path to the addon\'s image directory'
  end

  describe '.scripts_path' do
    it 'returns the absolute or relative path to the addon\'s javascript directory'
  end

  describe '.styles_path' do
    it 'returns the absolute or relative path to the addon\'s stylesheet directory'
  end

  describe '.views_path' do
    it 'returns the absolute or relative path to the addon\'s view directory'
  end

  describe '.views' do
    it 'has been depricated'
  end

  describe '.images' do
    it 'returns a list of image files that the addon utilizes'
  end

  describe '.scripts' do
    it 'returns a list of JavaScript files that the addon utilizes'
  end

  describe '.styles' do
    it 'returns a list of stylesheets that the addon utilizes'
  end

  describe '.stylesheets' do
    it 'returns a list of stylesheets that the addon utilizes (without partials)'
  end

  describe '.title' do
    it 'returns the friendly name for the addon'
  end

  describe '.machine_name' do
    it 'returns a name for the addon that would be appropriate for URLs'
  end

  describe '.all' do
    it 'should return an Array of all AddonBase decendants'
  end

  describe '.all_by_type' do
    it 'should return a Hash of all AddonBase decendants, keyed by addon type'
  end

  describe '.enabled?' do
    it 'checks to see if an addon is available for use'
  end

  describe '.disabled?' do
    it 'returns false if an addon is unavailable'
  end

  describe '.enabled' do
    it 'returns a list of addons which are available for use'
  end

  describe '.disabled' do
    it 'returns a list of deactivated addons'
  end

  describe '.enable!' do
    it 'marks an AddonBase decendant as available'
  end

  describe '.disable!' do
    it 'marks an AddonBase decendant as not available. should be called before removing the addon from the project'
  end

  describe '.describe' do
    it 'allows an addon do declare a short description about itself'
  end

  describe '.description' do
    it 'returns a short phrase about the addon'
  end

  describe '.register_setting' do
    it 'allows an addon to save a setting for later use'
  end

  describe '.setting' do
    it 'retrieves a setting for use'
  end

  describe '.settings' do
    it 'retrieves all registered settings'
  end

  describe '.addon_types' do
    it 'acts as a list of addon types at a particular scope'
  end
end
