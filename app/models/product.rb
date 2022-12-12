class Product < ApplicationRecord
  has_many :line_items
  scope :pages, ->(entries) {((Product.count * 1.0) / (entries * 1.0)).ceil}

end
