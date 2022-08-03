class CreatePercentageFeatureSwitches < ActiveRecord::Migration[6.0]
  shard :none
  def change
    create_table :percentage_feature_switches do |t|
      t.string  :name
      t.integer :threshold
      t.json    :conditions
      t.boolean :active
      t.string  :comment_author
      t.text    :comment_note

      t.timestamps
    end

    add_index :percentage_feature_switches, %i[name active]
  end
end
