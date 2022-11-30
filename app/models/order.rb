class Order < ApplicationRecord
  belongs_to :referrer
  belongs_to :customer
  belongs_to :address
  has_many :line_items

  scope :test, lambda { { :joins => :customer, :conditions => {:customer => {:id => Order.customer_id} } } }
  scope :with_customer, -> {where(customers: id == customer_id)}

  def testx
    @p = Order.joins(:customer).where(customers: id == customer_id)
  end

end
