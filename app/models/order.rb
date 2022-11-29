class Order < ApplicationRecord
  belongs_to :referrer
  belongs_to :customer
  belongs_to :address
  has_many :line_items

  scope :test, lambda { { :joins => :customer, :conditions => {:customer => {:id => Order.customer_id} } } }

end
