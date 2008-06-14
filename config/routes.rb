# ============================================================================
# e-archia: routes.rb
# author: nunojobpinto[at]gmail[dot]com                                      
# ============================================================================
ActionController::Routing::Routes.draw do |map|
  map.resources :groups

  # ==========================================================================
  # root
  # ==========================================================================
  map.root :controller => 'stories'

  # ==========================================================================
  # map_resources
  # ==========================================================================
  map.resources :projects
  map.resources :users
  map.resources :stories

  # ==========================================================================
  # sessions controller
  # ==========================================================================
  map.signout '/sair',
  :controller => 'session',
  :action => 'signout'

  map.signin '/entrar',
  :controller => 'session',
  :action => 'signin'
  
  # ==========================================================================
  # search controller
  # ==========================================================================
  map.search '/procurar',
  :controller => 'search',
  :action => 'index'
  
  map.do_search '/procurar/:query',
  :controller => 'search',
  :action => 'search'

  map.search_stories '/procurar/artigo',
  :controller => 'search',
  :action => 'search_stories'
  
  map.search_projects '/procurar/trabalho',
  :controller => 'search',
  :action => 'search_projects'
  
  map.search_files '/procurar/ficheiros',
  :controller => 'search',
  :action => 'search_files'

  # ==========================================================================
  # users controller
  # ==========================================================================
  map.utilizador  '/utilizador/:username', 
  :controller => 'users', 
  :action => 'show_by_username'

  map.editar_utilizador '/utilizadores/editar/:id',
  :controller => 'users',
  :action => 'edit'

  map.congelar_utilizador 'utilizadores/congelar/:id',
  :controller => 'users',
  :action => 'enable'

  map.signup '/registro',
  :controller => 'users',
  :action => 'new'

  # ==========================================================================
  # stories controller
  # ==========================================================================
  map.artigo '/artigo/:permalink', 
  :controller => 'stories', 
  :action => 'show_by_permalink'

  map.novo_artigo '/artigos/novo', 
  :controller => 'stories', 
  :action => 'new'

  map.subscrever '/subscrever',
  :controller => 'stories',
  :action => 'index',
  :format => 'rss'

  map.feed '/subscrever',
  :controller => 'stories',
  :action => 'index',
  :format => 'rss'

  map.connect '/feed',
  :controller => 'stories',
  :action => 'index',
  :format => 'rss'
end