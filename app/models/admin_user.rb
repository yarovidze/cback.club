class AdminUser < ApplicationRecord
  validates :email, 'valid_email_2/email': { strict_mx: true }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  

end
