# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :uuid, limit: 36, null: false, unique: true
      t.string :name, null: false
      t.string :full_domain, null: false, unique: true
      t.string :time_zone, limit: 100

      t.timestamps
    end
  end
end
