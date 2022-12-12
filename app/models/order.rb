class Order < ApplicationRecord
  belongs_to :referrer,:optional => true
  belongs_to :customer
  has_many :line_items

  scope :test, lambda { { :joins => :customer, :conditions => {:customer => {:id => Order.customer_id} } } }
  scope :with_customer, -> {where(customers: id == customer_id)}
  scope :pages, ->(entries) {((Order.count * 1.0) / (entries * 1.0)).ceil}
  scope :new_order_count, -> {Order.order(created_at: :desc).where('lower(status)= ?','mới tạo').count}
  scope :prepared_order_count, -> {Order.order(created_at: :desc).where('lower(status)= ?','Sẵn Sàng Giao'.downcase).count}
  scope :shipped_order_count, -> {Order.order(created_at: :desc).where('lower(status)= ?','Giao Thành Công'.downcase).count}
  scope :completed_order_count, -> {Order.order(created_at: :desc).where('lower(status)= ?','Hoàn Tất Đơn'.downcase).count}


  def testx
    @p = Order.joins(:customer).where(customers: id == customer_id)
  end

end
