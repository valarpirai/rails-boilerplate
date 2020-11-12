class AddProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references  :account, foreign_key: true, null: false
      t.string      :name, null: false
      t.string      :uuid, null: false
      t.string      :description
      t.text        :config, default: nil
      t.timestamps
    end

    add_index :projects, %i[account_id uuid], unique: true
    add_index :projects, %i[uuid], unique: true
  end
end
