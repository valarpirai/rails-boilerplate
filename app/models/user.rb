class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to_account

  concerned_with :validations, :callbacks

  def self.unscoped
    return super.where(account_id: Account.current.id) if Account.current
    super
  end
end
