class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :cards
  has_many :favorites
  has_many :transactions
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
end
