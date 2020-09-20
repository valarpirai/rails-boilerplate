class EmailNotification < ApplicationRecord
  belongs_to_account

  serialize :content, Hash
  serialize :options, Hash 
end
