class AddActivity < ActiveRecord::Migration[5.2]
  shard :all
  def change
    create_table :activities do |t|
      t.bigint      :account_id, null: false
      t.bigint      :user_id, null: false
      t.string      :description, null: false
      t.integer     :notable_id, null: false
      t.string      :notable_type, null: false
      t.text        :activity_data, default: nil
      t.timestamps
    end

    add_index :activities, %i[account_id created_at], unique: true
  end
end
