class SessionController < ApplicationController
  skip_before_filter :check_authentication, :check_authorization

  def index
    redirect_to root_path
  end
  
  def signin 
    if request.post? 
      session[:user] = User.authenticate(params[:username], params[:password]).id 
      unless session[:intended_action].blank? || session[:intended_controller].blank?
        redirect_to :action => session[:intended_action], 
        :controller => session[:intended_controller]
        session[:intended_action] = nil
        session[:intended_controller] = nil
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
    rescue SessionController::RuntimeError
      flash[:error] = 'A autenticação falhou'
      redirect_to root_path
  end
  
  def signout 
    session[:user] = nil
    redirect_to root_path
  end
  
end