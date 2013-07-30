Rails.configuration.middleware.use Browser::Middleware do
  redirect_to upgrade_path unless browser.modern? || browser.name == 'Other'
end