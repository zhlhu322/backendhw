class User < ApplicationRecord
  has_many :missions, dependent: :destroy
  validates :name, presence: { message: "can't be blank" }
  validates :email, presence: { message: "can't be blank" }, uniqueness: { message: "must be unique" }
end
