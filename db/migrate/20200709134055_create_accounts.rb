class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :uuid
      t.string :name
      t.string :full_domain
      t.string :time_zone

      t.timestamps
    end
  end
end
