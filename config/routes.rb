ActionController::Routing::Routes.draw do |map|

  map.resources :children, :collection => { :search => :get,
                                            :export_photos_to_pdf => :post,
                                            :advanced_search => :get,
                                            :export_csv => :post,
                                            :export_data => :post,
                                            :suspect_records => :get},
                :member => {:export_photo_to_pdf => :get} do |child|
    child.resource :history, :only => :show
    child.resources :attachments, :only => :show    
  end
  
  map.child_ids "/children-ids", :controller => "child_ids", :action => "all"
  map.edit_photo '/children/:id/photo/edit', :controller => 'children', :action => 'edit_photo', :conditions => {:method => :get }
  map.update_photo '/children/:id/photo', :controller => 'children', :action => 'update_photo', :conditions => {:method => :put }

  map.photos_index "/children/:child_id/photos_index", :controller => "child_media", :action => "index"
  map.manage_photos "/children/:child_id/photos", :controller => "child_media", :action => "manage_photos"

  map.child_audio "/children/:child_id/audio/:id", :controller => "child_media", :action => "download_audio"
  map.child_photo "/children/:child_id/photo/:photo_id", :controller => "child_media", :action => "show_photo"
  map.child_legacy_photo "/children/:child_id/photo", :controller => "child_media", :action => "show_photo"
  map.child_select_primary_photo "children/:child_id/select_primary_photo/:photo_id", :controller => "children", :action => "select_primary_photo", :conditions => {:method => :put}
  map.child_legacy_resized_photo "/children/:child_id/resized_photo/:size", :controller => "child_media", :action => "show_resized_photo"
  map.child_resized_photo "/children/:child_id/photo/:photo_id/resized/:size", :controller => "child_media", :action => "show_resized_photo"
  map.child_thumbnail "/children/:child_id/thumbnail/:photo_id", :controller => "child_media", :action => "show_thumbnail", :photo_id => nil
  map.child_filter "/children/filter/:status", :controller => "children", :action => "index"  

  map.resources :users
  map.resources :user_preferences
  map.admin 'admin', :controller=>"admin", :action=>"index"
  map.resources :sessions, :except => :index
  map.resources :password_recovery_requests, :only => [:new, :create]
  map.hide_password_recovery_request 'password_recovery_request/:password_recovery_request_id/hide', :controller => "password_recovery_requests", :action => "hide", :via => :delete

  map.login 'login', :controller=>'sessions', :action =>'new'
  map.logout 'logout', :controller=>'sessions', :action =>'destroy'

  map.enable_form 'form_section/enable', :controller => 'form_section', :action => 'enable', :value => true, :conditions => {:method => :post}
  map.disable_form 'form_section/disable', :controller => 'form_section', :action => 'enable', :value => false
  map.save_order "/form_section/save_order", :controller => "form_section", :action => "save_order"
  map.save_order_single "/form_section/save_order_single", :controller => "form_section", :action => "save_order_single"

  map.session_active '/active', :controller => 'sessions', :action => 'active'
  map.resources :formsections, :controller=>'form_section' do |form_section|
    additional_field_actions = FieldsController::FIELD_TYPES.inject({}){|h, type| h["new_#{type}"] = :get; h }
    additional_field_actions[:new] = :get
    additional_field_actions[:edit] = :get
    additional_field_actions[:update] = :post
    additional_field_actions[:move_up] = :post
    additional_field_actions[:move_down] = :post
    additional_field_actions[:delete] = :post
    additional_field_actions[:toggle_fields] = :post

    form_section.resources :fields, :controller => 'fields', :collection => additional_field_actions
  end

  map.choose_field 'form_section/:formsection_id/choose_field', :controller => 'fields', :action => 'choose'

  map.published_form_sections '/published_form_sections', :controller => 'publish_form_section', :action => 'form_sections'

  map.resources :advanced_search, :only => [:index, :new]
  map.advanced_search_index 'advanced_search/index', :controller => 'advanced_search', :action => 'index'

  map.resources :form_section

  map.resources :fields

  map.resources :contact_information

  map.resources :highlight_fields, :collection => { :remove => :post }

  map.root :controller => 'home', :action => :index

end
