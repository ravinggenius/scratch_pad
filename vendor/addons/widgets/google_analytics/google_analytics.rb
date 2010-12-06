class GoogleAnalytics < Widget
  def self.enable
    register_setting 'widget.google_analytics.account_code', 'Account Code', 'UA-xxxxxxx-xx'
    super
  end
end
