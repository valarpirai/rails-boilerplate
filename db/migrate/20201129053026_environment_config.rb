class EnvironmentConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :environment_config do |t|
      t.references  :account, foreign_key: true, null: false
      t.references  :environment, foreign_key: true, null: false
      t.references  :feature_flag, foreign_key: true, null: false
      t.json        :config
      t.boolean     :deleted, default: false
      t.timestamps
    end

    add_index :environment_config, %i[account_id environment_id feature_flag_id], unique: true, name: :unique_config
  end
end
