class Mission < ApplicationRecord
  validates :name, presence: { message: "can't be blank" }
  validates :description, presence: { message: "can't be blank" }
  validates :end_date, comparison: { greater_than: Time.current, message: "must be after the creation date" }

  enum :state, {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed"
  }

  def self.search(query)
    return all if query.blank?
    where("name ILIKE ?", "%#{query}%")
    .or(where(state: query))
  end

  scope :controller_sort, ->(sort_key, direction = :DESC) {
    return all if sort_key.blank?
    case sort_key
    when "created_at"
      order(created_at: direction)
    when "end_date"
      order(:end_date)
    else
      order(:id)
    end
  }
end
