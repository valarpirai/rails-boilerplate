class CreateShardMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :shard_mappings do |t|
      t.bigint :account_id, null: false
      t.string :shard_name, null: false, lentgh: 30
      t.integer :status, null: false, limit: 2 , default: 200
    end
    add_index :shard_mappings, %i[account_id], unique: true
  end
end
