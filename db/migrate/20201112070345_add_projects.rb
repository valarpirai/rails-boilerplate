class AddProjects < ActiveRecord::Migration[5.2]
  shard :all
  def change
    create_table :projects do |t|
      t.bigint      :account_id, null: false
      t.string      :name, null: false
      t.string      :uuid, null: false
      t.string      :description
      t.text        :config, default: nil
      t.boolean     :deleted, default: false
      t.timestamps
    end

    add_index :projects, %i[account_id uuid], unique: true
    add_index :projects, %i[account_id name], unique: true
    add_index :projects, %i[uuid], unique: true
  end
end
