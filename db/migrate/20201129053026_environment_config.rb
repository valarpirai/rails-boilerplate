class EnvironmentConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :environment_configs do |t|
      t.references  :account, null: false
      t.references  :environment, null: false
      t.references  :feature_flag, null: false
      t.json        :config
      t.boolean     :deleted, default: false
      t.timestamps
    end

    add_index :environment_configs, %i[account_id environment_id feature_flag_id], unique: true, name: :unique_config
  end
end
