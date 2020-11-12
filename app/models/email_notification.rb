class EmailNotification < ApplicationRecord
  belongs_to_account

  serialize :content, Hash
  serialize :options, Hash

  # Notification Type
  USER_ACTIVATION = 1
  PASSWORD_RESET = 2
  ADDITIONAL_EMAIL_VERIFICATION = 3
end
