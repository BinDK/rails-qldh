class Order < ApplicationRecord
  belongs_to :referrer,:optional => true
  belongs_to :customer
  has_many :line_items

  scope :test, lambda { { :joins => :customer, :conditions => {:customer => {:id => Order.customer_id} } } }
  scope :with_customer, -> {where(customers: id == customer_id)}
  scope :pages, ->(entries) {((Order.count * 1.0) / (entries * 1.0)).ceil}

  def testx
    @p = Order.joins(:customer).where(customers: id == customer_id)
  end

end
