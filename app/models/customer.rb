class Customer < ApplicationRecord
  has_many :addresses
  validates :phone, presence: true, uniqueness: true
end
