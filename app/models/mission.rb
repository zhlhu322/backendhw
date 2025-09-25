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
    where("name ILIKE ?", "%#{query}%")
    .or(where(state: query))
  end
end
