class User < ApplicationRecord
  belongs_to :user_role

  has_secure_password
  has_secure_token :authentication_token
  after_create :generate_authentication_token, unless: Proc.new { admin? }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :accessible_products
  has_many :products, through: :accessible_products
  has_many :transactions

  has_paper_trail


  def admin?
    user_role&.role == 'admin'
  end


  def generate_authentication_token
    self.authentication_token = SecureRandom.hex(10)
    save!
  end
  def self.authenticate_with_token(token)
    User.find_by(authentication_token: token)
  end

end