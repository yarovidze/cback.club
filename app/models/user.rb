class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2, facebook]

  has_many :cards
  has_many :favorites
  has_many :transactions


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      puts user
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
