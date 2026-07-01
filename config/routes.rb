# Next Level™ Menu Manager — Routes

Rails.application.routes.draw do
  # Per-project menu order save endpoint
  post 'projects/:project_id/nl_menu_order',
       to:  'nl_menu_manager#save_project_order',
       as:  'nl_menu_manager_project_order'
end
