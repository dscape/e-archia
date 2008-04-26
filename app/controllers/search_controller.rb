# ============================================================================
# e-archia: search controller
# author: nunojobpinto[at]gmail[dot]com
# ============================================================================
class SearchController < ApplicationController
  # ==========================================================================
  # this is public
  # ==========================================================================
  skip_before_filter :check_authentication, :check_authorization
  
  def index
  end
  
  def search_stories
    if request.post?
      query = '%' + params[:query].to_s + '%'
      @stories = Story.find(:all, :conditions => ["title like ? or contents like ?", query, query])
      @size = @stories.size
    end
  end

  def search_projects
    if request.post?
      query = '%' + params[:query].to_s + '%'
      @projects = Project.find(:all, 
      :conditions => ["title like ? or contents like ? or subtitle like ?", query, query, query])
      @size = @projects.size
    end
  end
end