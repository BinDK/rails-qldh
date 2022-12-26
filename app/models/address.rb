class Address < ApplicationRecord
  belongs_to :customer

  validates_presence_of :province_city,:district,:ward,:street
end
