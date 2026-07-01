Rails.configuration.to_prepare do
  require_dependency 'redmine/menu_manager'

  unless Redmine::MenuManager::MenuHelper
    .included_modules
    .include?(RedmineNlMenuManager::Patches::MenuManagerPatch)
    Redmine::MenuManager::MenuHelper.send(
      :include,
      RedmineNlMenuManager::Patches::MenuManagerPatch
    )
  end
end
