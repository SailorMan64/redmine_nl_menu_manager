# Next Level™ Menu Manager — after_init.rb

require_dependency 'redmine/menu_manager'

# Prepend MenuHelper patch
unless Redmine::MenuManager::MenuHelper
         .ancestors
         .include?(RedmineNlMenuManager::Patches::MenuManagerPatch)
  Redmine::MenuManager::MenuHelper.prepend(
    RedmineNlMenuManager::Patches::MenuManagerPatch
  )
end

# Prepend SettingsController patch to normalize checkbox saves
unless SettingsController
         .ancestors
         .include?(RedmineNlMenuManager::Patches::SettingsControllerPatch::InstanceMethods)
  SettingsController.prepend(
    RedmineNlMenuManager::Patches::SettingsControllerPatch::InstanceMethods
  )
end
