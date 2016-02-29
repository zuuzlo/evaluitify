Rebay2::Api.configure do |rebay2|
  rebay2.app_id = ENV["EBAY_APP_ID"]
  rebay2.tracking_id = ENV["EBAY_TRACKING_ID"]
  #rebay2.network_id = 'tracking partner for affiliate commissions'  # will default 9 if not specified
end