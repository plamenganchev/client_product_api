class Card < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :activation_number, presence: true
  validates :status, inclusion: { in: %w(active cancelled) }
end