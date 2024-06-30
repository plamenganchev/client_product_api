class UserRole < ApplicationRecord
  has_many :users

  validates :role, presence: true, uniqueness: true
end