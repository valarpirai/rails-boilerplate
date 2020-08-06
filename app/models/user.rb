class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :lockable,
         :recoverable, :rememberable, :validatable, :confirmable
  belongs_to_account

  concerned_with :validations, :callbacks

  # Overridden
  def self.unscoped
    return super unless Account.current
    super.where(account_id: Account.current.id)
  end

  def generate_reset_password_token
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    self.reset_password_sent_at = Time.now
    self.reset_password_token = hashed
    save!
    @token
  end

  def after_database_authentication
    
  end
end
