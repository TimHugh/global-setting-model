class CreateGlobalSetting < ActiveRecord::Migration
  def change
    create_table :global_settings do |t|
      t.string :key,       null: false
      t.integer :datatype, null: false, default: 0

      t.string :string
      t.integer :integer
      t.float :float
      t.boolean :boolean

      t.timestamps         null: false
    end

    add_index :global_settings, :key
  end
end
