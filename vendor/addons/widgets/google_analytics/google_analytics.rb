class GoogleAnalytics < Widget
  def self.install
    register_setting 'addon.widget.google_analytics.account_code', 'Account Code', 'UA-xxxxxxx-xx'
  end
end
