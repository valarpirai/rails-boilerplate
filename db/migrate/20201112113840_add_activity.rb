class AddActivity < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references  :account, foreign_key: true, null: false
      t.references  :user, null: false
      t.string      :description, null: false
      t.integer     :notable_id, null: false
      t.string      :notable_type, null: false
      t.text        :activity_date, default: nil
      t.timestamps
    end

    add_index :activities, %i[account_id created_at], unique: true
  end
end
