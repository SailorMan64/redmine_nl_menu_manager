# Next Level™ Menu Manager — core service module
# All ordering/visibility logic lives here, keeping the patch thin.

module RedmineNlMenuManager
  autoload :Patches, File.dirname(__FILE__) + '/redmine_nl_menu_manager/patches/menu_manager_patch'
end

module NlMenuManager
  MANAGED_MENUS = %w[project_menu application_menu top_menu].freeze

  # Returns the global config hash for a given menu key.
  # Format: { 'overview' => { 'position' => 1, 'visible' => true }, ... }
  def self.global_config(menu_key)
    cfg = Setting.plugin_next_level_redmine_menu_manager[menu_key]
    cfg.is_a?(Hash) ? cfg : {}
  end

  # Sorts and filters menu children according to global config and
  # optional per-project enabled_modules overrides.
  def self.sort_and_filter(children, global_cfg, menu, project = nil)
    # Build per-project module map if applicable
    project_modules = {}
    if project.is_a?(Project) && menu.to_sym == :project_menu
      begin
        project.enabled_modules.each do |em|
          project_modules[em.name] = {
            position: em.respond_to?(:position) ? em.position : nil,
            visible:  em.respond_to?(:visible)  ? em.visible  : true
          }
        end
      rescue
        # enabled_modules not yet migrated — degrade gracefully
      end
    end

    # Filter hidden items
    children = children.select do |item|
      name = item.name.to_s
      # Per-project visible override takes priority
      if project_modules.key?(name) && !project_modules[name][:visible].nil?
        next project_modules[name][:visible]
      end
      # Global visible — handle boolean false, string 'false', or nil
      if global_cfg.key?(name)
        v = global_cfg[name]['visible']
        next !(v == false || v == 'false' || v.to_s == '0')
      end
      true  # not configured — show by default
    end

    # Sort
    children.sort_by.with_index do |item, i|
      name = item.name.to_s
      # Per-project position takes priority
      if project_modules.key?(name) && project_modules[name][:position].present?
        next [0, project_modules[name][:position], i]
      end
      # Global position
      if global_cfg.key?(name) && global_cfg[name]['position'].present?
        next [0, global_cfg[name]['position'].to_i, i]
      end
      # No config — append after all configured items, in registration order
      [1, 0, i]
    end
  end

  # Returns all items for a menu as an ordered array of hashes for the UI.
  # Merges live menu items with any saved config so nothing is ever lost.
  def self.menu_items_for_ui(menu_key)
    menu_sym = menu_key.to_sym
    live_items = Redmine::MenuManager.items(menu_sym).root.children rescue []
    global_cfg = NlMenuManager.global_config(menu_key)

    # Build a position-sorted list; unsaved items append at end
    live_items.map.with_index do |item, i|
      name = item.name.to_s
      cfg  = global_cfg[name] || {}
      {
        name:     name,
        label:    NlMenuManager.item_label(item),
        position: cfg['position']&.to_i || (live_items.count + i),
        visible:  cfg.key?('visible') ? cfg['visible'] != false : true
      }
    end.sort_by { |h| [h[:position], h[:name]] }
  end

  # Extracts a human-readable label from a menu item.
  def self.item_label(item)
    caption = item.caption
    if caption.is_a?(Symbol)
      ::I18n.t(caption, default: caption.to_s.humanize)
    elsif caption.respond_to?(:call)
      caption.call rescue item.name.to_s.humanize
    else
      caption.to_s
    end
  end

  # Normalizes raw plugin settings params before save.
  # HTML checkboxes send nothing when unchecked — we must explicitly
  # write visible: false for any item whose visible key is absent.
  def self.normalize_settings(raw)
    result = {}
    MANAGED_MENUS.each do |menu_key|
      result[menu_key] = {}
      next unless raw[menu_key].is_a?(Hash)

      # Get the full live item list so we know ALL possible names
      live_names = Redmine::MenuManager.items(menu_key.to_sym)
                     .root.children.map { |i| i.name.to_s } rescue []

      live_names.each do |name|
        cfg = raw[menu_key][name] || {}
        result[menu_key][name] = {
          'position' => cfg['position'].to_i,
          'visible'  => cfg['visible'].to_s == '1'
        }
      end
    end
    result
  end

  # Builds a settings hash from form params.
  # params format: { 'project_menu' => { 'overview' => { 'position' => '1', 'visible' => '1' } } }
  def self.settings_from_params(params)
    result = {}
    MANAGED_MENUS.each do |menu_key|
      result[menu_key] = {}
      next unless params[menu_key].is_a?(Hash)
      params[menu_key].each do |name, cfg|
        result[menu_key][name] = {
          'position' => cfg['position'].to_i,
          'visible'  => cfg['visible'].to_s == '1'
        }
      end
    end
    result
  end
end
