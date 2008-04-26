# ============================================================================
# e-archia: stories controller
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class StoriesController < ApplicationController
  # ==========================================================================
  # ignore before filters for (defined in application.rb)
  #
  # não mudar tem que ser coincidente com o que ta na migração
  # ==========================================================================
  skip_before_filter :check_authentication, :check_authorization,
                     :only => [ :index, :show, :show_by_permalink, :search ]

  # ==========================================================================
  # auth not required - available to anyone
  # ========================================================================== 
  def index
    @user = User.find_by_id(session[:user])
    @stories = Story.find :all,
    :order => 'updated_at DESC',
    :limit => 5
  end

  def show
    @story = Story.find(params[:id])
  end

  def show_by_permalink
    @story = Story.find_by_permalink(params[:permalink])
    render :action => 'show'
  end
  
  def search
    if request.post?
      query = '%' + params[:story] + '%'
      @stories = Story.find(:all, :conditions => ["title like ? or contents like ?", query, query])
    end
  end

  # ==========================================================================
  # auth required - available to members
  # ========================================================================== 
  def new
    @story = Story.new
  end

  def edit
    @story = Story.find(params[:id])
    if @story.user_id != session[:user]
      flash[:error] = 'Este artigo não é teu. Não o podes editar'
      redirect_to root_path
    end
  end

  def create
    @story = Story.new(params[:story])
    @story.user = User.find_by_id(session[:user])

    if @story.save
      flash[:notice] = 'Artigo criado com sucesso'
      redirect_to story_path(@story)
    else
      render :action => 'new'
    end
  end

  def update
    @story = Story.find(params[:id])
    if @story.user_id != session[:user]
      flash[:error] = 'Este artigo não é teu. Não o podes actualizar'
      redirect_to root_path
    end
    
    if @story.update_attributes(params[:story])
      flash[:notice] = 'Artigo actualizado com sucesso'
      redirect_to story_path(@story)
    else
      render :action => 'edit'
    end
  end

  # ==========================================================================
  # auth required                                                       ADMIN
  # ==========================================================================
  def destroy
    @story = Story.find(params[:id])
    if @story.destroy
      flash[:notice] = "Artigo apagado"			
    else											
      flash[:error]  = "Houve um problema ao apagar o artigo"	
    end												
    redirect_to stories_path
  end
end
