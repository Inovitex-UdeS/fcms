##
# When browser is not up-to-date, we will redirect to a page to say tp update or change the browser
class UpgradeController < ApplicationController
  skip_before_filter :authenticate_user!
end
