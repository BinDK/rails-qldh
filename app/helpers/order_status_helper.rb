module OrderStatusHelper

  def options_for_order_status(status)
    case status
    when 'Mới Tạo'
      render_options_for_new_order
    when 'Sẵn Sàng Giao'
      render_options_for_ready_to_delivery_order
    when 'Giao Thành Công'
      render_options_for_shipped_successful_order
    else
      render_options_for_default
    end
  end

  private

  def render_options_for_new_order
    content_tag(:option, 'Thay đỏi Trạng Thái', disabled: true, selected: true) +
      content_tag(:option, 'Sẵn Sàng Giao', id: '2') +
      content_tag(:option, 'Giao Thành Công', id: '3') +
      content_tag(:option, 'Hoàn Tất Đơn', id: '4') +
      content_tag(:option, 'Hủy', id: '5')
  end

  def render_options_for_ready_to_delivery_order
    content_tag(:option, 'Thay đỏi Trạng Thái', disabled: true, selected: true) +
      content_tag(:option, 'Giao Thành Công', id: '3') +
      content_tag(:option, 'Hoàn Tất Đơn', id: '4') +
      content_tag(:option, 'Hủy', id: '5')
  end

  def render_options_for_shipped_successful_order
    content_tag(:option, 'Thay đỏi Trạng Thái', disabled: true, selected: true) +
      content_tag(:option, 'Hoàn Tất Đơn', id: '4') +
      content_tag(:option, 'Hủy', id: '5')
  end

  def render_options_for_default
    content_tag(:option, 'Chọn Để Hủy', disabled: true, selected: true) +
      content_tag(:option, 'Hủy', id: '5')
  end
end