class UpgradeController < ApplicationController
  skip_before_filter :authenticate_user!
end
