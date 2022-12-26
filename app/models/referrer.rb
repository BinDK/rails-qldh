class Referrer < ApplicationRecord
  has_many :orders
  validates_presence_of :name,:phone,:banking_informations
end
