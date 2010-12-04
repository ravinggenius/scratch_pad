class GoogleAnalytics < Widget
  def self.enable
    register_setting 'addon.widget.google_analytics.account_code', 'Account Code', 'UA-xxxxxxx-xx'
    super
  end
end
