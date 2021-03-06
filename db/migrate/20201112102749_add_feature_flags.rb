class AddFeatureFlags < ActiveRecord::Migration[5.2]
  shard :all
  def change
    create_table :feature_flags do |t|
      t.bigint      :account_id, null: false
      t.bigint      :project_id, null: false
      t.string      :name, null: false
      t.string      :key, null: false
      t.string      :description
      t.boolean     :deleted, default: false
      t.text        :configs, default: nil
      t.datetime    :deleted_at, default: nil
      t.timestamps
    end

    add_index :feature_flags, %i[account_id name]
    add_index :feature_flags, %i[project_id name]
  end
end
