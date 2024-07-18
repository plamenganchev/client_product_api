class Brand < ApplicationRecord
  belongs_to :country
  has_many :products
  validates :name, presence: true
  validates :status,inclusion: { in: %w(active inactive) }


  has_paper_trail
end