class AddFeatureFlags < ActiveRecord::Migration[5.2]
  def change
    create_table :feature_flags do |t|
      t.references  :account, foreign_key: true, null: false
      t.references  :project, foreign_key: true, null: false
      t.string      :name, null: false
      t.string      :key, null: false
      t.string      :description
      t.boolean     :deleted, default: false
      t.text        :variations, default: nil
      t.timestamps
    end

    add_index :feature_flags, %i[account_id name], unique: true
  end
end
