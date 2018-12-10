module ApplicationHelper
  def body_controller
    params[:controller].split('/')[0]
  end

  def modal(type, options = {}, &block)
    options = { size: options } if options.is_a? String
    defaults = { type: type, size: 'md', body: false, arrows: false }
    locals = defaults.merge options
    locals[:captured] = block_given? ? capture(&block) : ''
    render partial: 'partials/modal', locals: locals
  end

  def page_cols(options)
    options = { md: options.to_i } if options.respond_to? :to_i

    set_main_row(options)
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  private

  def set_main_row(options)
    row_class = options.map do |k, v|
      "col-#{k}-#{v} offset-#{k}-#{(12 - v) / 2}"
    end
    content_for :main_row_class, row_class.join(' ')
  end
end
