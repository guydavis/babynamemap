ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Short cuts to show a boy or girls name directly, good for links 
  map.connect 'boys/:search_name', :controller => 'map', :action=>'search', :gender => 'MALE'
  map.connect 'girls/:search_name', :controller => 'map', :action=>'search', :gender => 'FEMALE'

  # OpenSearch for Firefox and IE auto-complete
  map.connect 'name/opensearch_complete/boys/:name', :controller=>'name', 
   :action=>'opensearch_complete', :gender=>'MALE'
  map.connect 'name/opensearch_complete/girls/:name', :controller=>'name', 
   :action=>'opensearch_complete', :gender=>'FEMALE'
 
  # Cacheable path for the overall Browse by Gender table grid views
  map.connect 'name/browse/:gender/:letter', :controller => 'name', :action=>'browse'
  map.connect 'name/browse/:gender', :controller => 'name', :action=>'browse'
  
  # Cacheable path for the regional popular table grid views
  map.connect 'region/popular/:gender/:region_id/:letter', :controller => 'region', :action=>'popular'
  map.connect 'region/popular/:gender/:region_id', :controller => 'region', :action=>'popular'
  
  # Popularity in a region Gruff graphs
  map.connect '/name/pop_in_region_graph/:id/:region_id', :controller => 'name', :action => 'pop_in_region_graph'

  # Default main page on visiting site
  map.connect '', :controller => "map", :action => "index"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  
  # Simple-Catpcha used to prevent comment and image spam
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  
  # JSON and XML API for data access from other applications and scrapers
  map.connect 'api/regions.:format', :controller => 'region', :action => 'api_list'
  map.connect 'api/name/:id.:format', :controller => 'name', :action => 'api_show'
  map.connect 'api/stats/:id.:format', :controller => 'region', :action => 'api_stats'
  map.connect 'api/years/:id.:format', :controller => 'region', :action => 'api_years'
  map.connect 'api/where/:id.:format', :controller => 'name', :action => 'api_where'
  map.connect 'api/search/:gender/:name.:format', :controller => 'name', :action => 'api_search'
end
