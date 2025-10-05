class Mission < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "can't be blank" }
  validates :description, presence: { message: "can't be blank" }
  validates :end_date, comparison: { greater_than: Time.current, message: "must be after the creation date" }
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  attr_accessor :tag_name
  before_save :process_tag_name

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

  def process_tag_name
    name_to_use = self.tag_name.to_s.strip
    return if name_to_use.blank?
    tag_instance = Tag.find_or_create_by!(name: name_to_use)
    self.tags << tag_instance unless self.tags.include?(tag_instance)
  end

  def self.search(query, sort_key = nil)
    if query.blank?
      all.controller_sort(sort_key)
    else
      all.left_joins(:tags).where("missions.name ILIKE :q OR missions.state = :sq OR tags.name ILIKE :q", q: "%#{query}%", sq: query)
                          .distinct.controller_sort(sort_key)
    end
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
