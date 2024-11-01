class FacebookController < ApplicationController
  layout "occupy_facebook_layout"

  def occupy_facebook
    render "/pages/occupy_main_street"
  end
end
