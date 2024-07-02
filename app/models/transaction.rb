class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :product

  enum transaction_type: { spending: 0, cancel: 1 }

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_paper_trail
end