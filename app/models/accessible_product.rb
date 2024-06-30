class AccessibleProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_paper_trail
end