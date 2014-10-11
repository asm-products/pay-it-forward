class Identity < ActiveRecord::Base
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
