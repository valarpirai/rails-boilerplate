# frozen_string_literal: true

class CreateDomainMappings < ActiveRecord::Migration[5.2]
  shard :none
  def change
    create_table :domain_mappings do |t|
      t.bigint :account_id, null: false
      t.string :domain, null: false

      t.timestamps
    end

    add_index :domain_mappings, %i[domain], unique: true
  end
end
