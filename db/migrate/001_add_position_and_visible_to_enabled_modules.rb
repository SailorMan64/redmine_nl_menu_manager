# Next Level™ Menu Manager — Migration 001
# Adds per-project menu item position and visibility to the enabled_modules table.
# position: nil = inherit global order; integer = project-specific position
# visible:  true (default) = show; false = hidden for this project

class AddPositionAndVisibleToEnabledModules < ActiveRecord::Migration[7.0]
  def up
    unless column_exists?(:enabled_modules, :position)
      add_column :enabled_modules, :position, :integer, default: nil
    end
    unless column_exists?(:enabled_modules, :visible)
      add_column :enabled_modules, :visible, :boolean, default: true, null: false
    end
  end

  def down
    remove_column :enabled_modules, :position if column_exists?(:enabled_modules, :position)
    remove_column :enabled_modules, :visible  if column_exists?(:enabled_modules, :visible)
  end
end
