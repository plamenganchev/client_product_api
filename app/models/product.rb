class Product < ApplicationRecord
  belongs_to :brand
  has_and_belongs_to_many  :users, :join_table => :users_products
  has_many :transactions

  validates :name, :price, presence: true
  validates :status, inclusion: { in: %w(active inactive) }

  scope :active, -> { joins(:brand).where(products: { status: 'active' }, brands: { status: 'active' }) }
  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_description, ->(description) { where("description LIKE ?", "%#{description}%") if description.present? }
  scope :search_by_brand_name, ->(brand_name) { joins(:brand).where("brands.name LIKE ?", "%#{brand_name}%") if brand_name.present? }
  scope :filter_by_price_range, ->(min_price, max_price) { where(price: min_price..max_price) if min_price.present? && max_price.present? }

  has_paper_trail
end