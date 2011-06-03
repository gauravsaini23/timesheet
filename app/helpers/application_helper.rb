# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def redirect_to_home

    return redirect_to :action => "home", :controller => "users"
  end  
end
