class DropPhases < ActiveRecord::Migration
  def up
    drop_table :phases
  end

  def down
  end
end
