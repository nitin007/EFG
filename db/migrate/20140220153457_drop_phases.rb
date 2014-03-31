class DropPhases < ActiveRecord::Migration
  def up
    drop_table :phases
  end

  def down
    create_table :phases, force: true do |t|
      t.string :name
      t.integer :created_by_id
      t.integer :modified_by_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
