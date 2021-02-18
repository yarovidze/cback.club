class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :cards
  has_many :favorites
  has_many :transactions
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      puts user
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
