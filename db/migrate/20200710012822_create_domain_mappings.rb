# frozen_string_literal: true

class CreateDomainMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :domain_mappings do |t|
      t.references :account, foreign_key: true, null: false
      t.string :domain, null: false, unique: true

      t.timestamps
    end
  end
end
