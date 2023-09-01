class Referrer < ApplicationRecord
  has_many :orders
  validates :name, :phone, :banking_informations, presence: true
  validates :phone, uniqueness: true
end
