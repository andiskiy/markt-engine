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
    options = options.respond_to?(:to_i) ? [options] : options.each_key.map { |key| "#{key}-#{options[key]}" }
    main_row(options)
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

  def indent_title_section(section)
    "› #{section}"
  end

  private

  def main_row(options)
    row_class = options.map { |v| "col-#{v}" }.join(' ')
    content_for :main_row_class, row_class
  end
end
