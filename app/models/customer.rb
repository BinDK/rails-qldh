class Customer < ApplicationRecord
  has_many :addresses
  has_many :orders
  validates :phone, presence: true, uniqueness: true
end
