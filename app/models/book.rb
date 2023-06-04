class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  scope :with_favorites, -> { left_outer_joins(:favorites).where.not(favorites: { id: nil }) }
  scope :without_favorites, -> { left_outer_joins(:favorites).where(favorites: { id: nil }) }
  scope :ordered_by_favorites_count, -> { order(favorites_count: :desc) }
  scope :preload_user, -> { includes(:user) }

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }



  def self.sorted_by_favorites_created_this_week
    created_this_week.with_favorites.ordered_by_favorites_count.preload_user
  end

  def self.sorted_by_favorites_and_without_favorites_created_this_week
    created_this_week.ordered_by_favorites_count.preload_user.or(without_favorites.created_this_week.preload_user)
  end

  def self.sorted_by_favorites
    with_favorites.ordered_by_favorites_count.preload_user.or(without_favorites.preload_user)
  end


end
