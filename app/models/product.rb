class Product < ApplicationRecord
  belongs_to :brand
  has_and_belongs_to_many  :users, :join_table => :users_products
  has_many :transactions

  validates :name, :price, presence: true
  validates :status, inclusion: { in: %w(active inactive) }


  has_paper_trail
end