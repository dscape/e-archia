# ============================================================================
# e-archia: projects controller
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class ProjectsController < ApplicationController
  
  
  # ==========================================================================
  # auth required                                                     MEMBERS
  # ==========================================================================
  def search
  end
  
  def index
    @projects = Project.find(:all)
  end

  def show
    @acm = {
     1  => 'General Literature',
     2  => 'Hardware',
     3  => 'Computer Systems Organization',
     4  => 'Software/Software Engineering',
     5  => 'Data',
     6  => 'Theory of Computation',
     7  => 'Mathematics of Computing',
     8  => 'Information Technology and Systems',
     9  => 'Computing Methodologies',
     10 => 'Computer Applications',
     11 => 'Computing Milieux'
    }
    @project = Project.find(params[:id])
  end
  
  def show_by_permalink
    @project = Project.find_by_permalink(params[:permalink])
    render :action => 'show'
  end

  def new
    @project = Project.new
    @acm = {
     'General Literature'                 => 1,
     'Hardware'                           => 2,
     'Computer Systems Organization'      => 3,
     'Software/Software Engineering'      => 4,
     'Data'                               => 5,
     'Theory of Computation'              => 6,
     'Mathematics of Computing'           => 7,
     'Information Technology and Systems' => 8,
     'Computing Methodologies'            => 9,
     'Computer Applications'              => 10,
     'Computing Milieux'                  => 11
    }
  end

  def edit
    @project = Project.find(params[:id])
    if @project.user_id != session[:user]
      flash[:error] = 'Este trabalho não é teu. Não o podes editar'
      redirect_to root_path
    end
  end

  def create
    @project = Project.new(params[:project])
    @project.user = User.find_by_id(session[:user])

    if @project.save
      @project.update_attribute :filepath, @project.path_to_file
      flash[:notice] = 'Trabalho criado com sucesso'
      redirect_to project_path(@project)
    else
      render :action => 'new'
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.user_id != session[:user]
      flash[:error] = 'Este trabalho não é teu. Não o podes actualizar'
      redirect_to root_path
    end
    
    params[:project][:filename] = @project.path_to_file
    
    if @project.update_attributes(params[:project])
      flash[:notice] = 'Trabalho actualizado com sucesso'
      redirect_to projects_path
    else
      render :action => 'edit'
    end
  end

  # ==========================================================================
  # auth required                                                       ADMIN
  # ==========================================================================
  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      flash[:notice] = "Trabalho apagado"			
    else											
      flash[:error]  = "Houve um problema ao apagar o trabalho"	
    end												
    redirect_to projects_path
  end
end
