class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users, dependent: :destroy
  # :命名, :参照するテーブル, :カラム指定
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # :命名, :中間テーブルを通す, :followerモデルのフォローされる側の情報を習得
  has_many :following_user, through: :follower, source: :followed
  # :命名, :中間テーブルを通す, :followedモデルのフォローする側の情報を習得
  has_many :follower_user, through: :followed, source: :follower
  
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms, dependent: :destroy

  validates :name, uniqueness: true, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
  validates :email, uniqueness: true, presence: true

  def self.guest
    find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    following_user.include?(user)
  end
  
end