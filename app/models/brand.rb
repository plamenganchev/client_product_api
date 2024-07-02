class Brand < ApplicationRecord
  has_many :products
  validates :name, presence: true
  validates :status,inclusion: { in: %w(active inactive) }


  has_paper_trail
end