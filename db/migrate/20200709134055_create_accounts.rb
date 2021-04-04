# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  shard :all

  def change
    create_table :accounts do |t|
      t.string :uuid, limit: 36, null: false
      t.string :name, null: false
      t.string :full_domain, null: false
      t.string :time_zone, limit: 100

      t.timestamps
    end

    add_index :accounts, %i[uuid], unique: true
    add_index :accounts, %i[full_domain], unique: true
  end
end
