class AddFeatureToAccount < ActiveRecord::Migration[6.0]
  shard :all
  def change
    add_column :accounts, :features, :string, limit: 64
  end
end
