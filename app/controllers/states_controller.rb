class StatesController < ApplicationController
  def index
    if session[:territory_id] && !request.path.include?("/states")
      redirect_to territory_root_path(Territory.find(session[:territory_id]))
    end
    
    respond_to do |format|
      format.html  {}
      format.plain { render :template => "index", :layout => false }
    end
  end
end