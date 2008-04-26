# ============================================================================
# e-archia: users controller
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class UsersController < ApplicationController
  # ==========================================================================
  # ignore before filters (only for)
  #
  # não mudar tem que ser coincidente com o que ta na migração
  # ==========================================================================
  skip_before_filter :check_authentication, :check_authorization,
                     :only => [ :show, :show_by_username, :new, :create ]

 # ==========================================================================
 # auth not required                                                  PUBLIC
 # ==========================================================================
  def index
    @users = User.find(:all)
  end

  def show
    @user ||=User.find(params[:id])
  end
  
  def show_by_username
    @user = User.find_by_username(params[:username])
    @quote = Quote.random
    @projects = @user.projects
    @stories = @user.stories
    render :action => 'show'
  end

  def new
    redirect_to root_path if session[:user]
    @user = User.new
    @quote = Quote.random
  end

  def create
    @user = User.new(params[:user])
    # only while rights/roles ain't properly set
    # erase for deploy
    @user.roles << Role.find_by_name('root')
    @quote = Quote.random
    
    if @user.save
        flash[:notice] = 'A sua conta foi criada'
        session[:user] = User.authenticate(@user.username, @user.password).id 
        redirect_to root_path
      else
        render :action => 'new'
      end
  end

  # ==========================================================================
  # auth required                                                     MEMBERS
  # ==========================================================================
  def edit
    @user ||= User.find(params[:id])
    @quote = Quote.random
    if @user.id != session[:user]
      flash[:error] = 'Só podes alterar o teu próprio perfil'
      redirect_to root_path
    end
  end
  
  def edit_by_username
    @user = User.find_by_username(params[:username])
    render :action => 'edit'
  end
  
  def update
    @user = User.find(params[:id])
    
    @user = User.find(params[:id])
    if @user.id != session[:user]
      flash[:error] = 'Só podes actualizar o teu próprio perfil'
      redirect_to root_path
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Utilizador actualizado com sucesso'
      redirect_to story_path(@story)
    else
      render :action => 'edit'
    end
  end
  
  # ==========================================================================
  # auth required                                                       ADMIN
  # ==========================================================================
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Artigo apagado"			
    else											
      flash[:error]  = "Houve um problema ao apagar o artigo"	
    end												
    redirect_to users_path
  end
  
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, !@user.enabled)
      flash[:notice] = "O utilizador foi congelado"
    else
      flash[:error] = "A operação falhou"
    end
    redirect_to users_path
  end
end
