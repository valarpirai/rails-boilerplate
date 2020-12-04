class Environment < ActiveRecord::Migration[5.2]
  def change
    create_table :environments do |t|
      t.bigint      :account_id, null: false
      t.bigint      :project_id, null: false
      t.string      :name, null: false
      t.string      :description
      t.boolean     :deleted, default: false
      t.timestamps
    end

    add_index :environments, %i[account_id project_id name], unique: true
  end
end
