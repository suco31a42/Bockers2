class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :post_images, dependent: :destroy
  has_one_attached :image

  validates :name, uniqueness: true, length: {minimum: 2, maximum: 20 }
  validates :email, uniqueness: true
end
