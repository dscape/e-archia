class ApplicationController < ActionController::Base
  filter_parameter_logging 'password', 'email'
  session :session_key => '_earchia_session_id'
  before_filter :check_authentication, 
  :check_authorization, 
  :except => [:signin] 

  protected

  def check_authentication
    unless session[:user] 
      session[:intended_action] = action_name
      flash[:notice] = "Para visitar essa página tem que iniciar sessão"
      redirect_to root_path
      return false 
    end 
  end 

  def check_authorization 
    user = User.find(session[:user]) 
    return true unless user.roles.find_by_name("root").nil?
    
    unless user.roles.detect{|role| 
      role.rights.detect{|right| 
        right.action == action_name && right.controller == self.class.controller_path
      }
    }
    
    flash[:notice] = "Não está autorizado a visitar esta página"
    redirect_to root_path
    return false 
  end 
end
end
