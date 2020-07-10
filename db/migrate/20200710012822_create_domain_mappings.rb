class CreateDomainMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_mappings do |t|
      t.references :account, foreign_key: true
      t.string :domain

      t.timestamps
    end
  end
end
