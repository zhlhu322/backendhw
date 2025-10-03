class Mission < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "can't be blank" }
  validates :description, presence: { message: "can't be blank" }
  validates :end_date, comparison: { greater_than: Time.current, message: "must be after the creation date" }
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :taggings,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:tag_name].blank? }

  enum :state, {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed"
  }

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }

  def self.search(query, sort_key = nil)
    return all if query.blank? && sort_key.blank?
    if query.blank?
      return all.controller_sort(sort_key)
    end
    all.left_joins(:tags).where("missions.name ILIKE :query OR " + "missions.state ILIKE :query OR " + "tags.name ILIKE :query", query: "%#{query}%")
                          .distinct.controller_sort(sort_key)
  end

  scope :controller_sort, ->(sort_key, direction = :DESC) {
    return all if sort_key.blank?
    case sort_key
    when "created_at"
      order(created_at: direction)
    when "end_date"
      order(:end_date)
    when "priority"
      order(priority: :desc)
    else
      order(:id)
    end
  }
end
