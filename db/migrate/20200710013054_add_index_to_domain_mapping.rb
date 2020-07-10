class AddIndexToDomainMapping < ActiveRecord::Migration[5.2]
  def change
    add_index :domain_mappings, :domain, unique: true
    change_column_null :domain_mappings, :domain, false
    change_column_null :domain_mappings, :account_id, false
  end
end
