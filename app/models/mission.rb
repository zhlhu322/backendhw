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

  def self.search(query)
    return all if query.blank?
    base_query_ids = Mission.select(:id).where("missions.name ILIKE ?", "%#{query}%")
                        .or(Mission.where(state: query)).map(&:id)
    tags_query_ids = Mission.joins(:tags).where("tags.name ILIKE ?", "%#{query}%")
                            .distinct.pluck(:id)
    combined_ids = base_query_ids | tags_query_ids
    Mission.where(id: combined_ids)
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
