class CreateEmailNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :email_notifications do |t|
      t.references  :account, null: false
      t.boolean     :admin_notification, default: true
      t.boolean     :user_notification, default: true
      t.integer     :notification_type, default: 0, null: false
      t.text        :content
      t.integer     :version, default: 1, null: false
      t.text        :options, default: nil
      t.timestamps
    end

    add_index :email_notifications, %i[account_id notification_type], unique: true
  end
end
