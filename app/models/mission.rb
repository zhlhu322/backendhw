class Mission < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "can't be blank" }
  validates :description, presence: { message: "can't be blank" }
  validates :end_date, comparison: { greater_than: Time.current, message: "must be after the creation date" }

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
    where("name ILIKE ?", "%#{query}%")
    .or(where(state: query))
    .or(where("? = ANY(tags)", query.to_s))
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

  def add_tag(new_tag)
    return tags if new_tag.blank?

    (tags.to_a << new_tag.to_s.strip).uniq
  end
end
