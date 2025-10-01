class User < ApplicationRecord
  has_secure_password
  has_many :missions, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  before_destroy :ensure_an_admin_remains, if: :admin?

  private
  def ensure_an_admin_remains
    if User.where(admin: true).count <= 1
      errors.add(:base, "管理者數量不能為0")
      throw(:abort)
    end
  end
end
