class Product < ApplicationRecord
  belongs_to :brand
  has_many :accessible_products
  has_many :users, through: :accessible_products
  has_many :transactions

  validates :name, :price, presence: true
  validates :status, inclusion: { in: %w(active inactive) }


  has_paper_trail
end