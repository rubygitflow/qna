class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:github]

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def author?(resource)
    resource.user_id == id
  end
  
  def voted?(resource)
    resource.votes.exists?(user_id: id)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
