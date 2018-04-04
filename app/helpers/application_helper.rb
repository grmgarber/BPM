module ApplicationHelper
  DATE_FORMAT = '%m/%d/%Y'.freeze

  def errors_for(model, attr)
    raw("<div class='attribute-error'>#{model.errors[attr].join(', ')}</div>")
  end

  def format_date(date)
    return '' if date.blank?
    date.strftime(DATE_FORMAT)
  end

  def report_year
    Rails.application.config_for(:report)['year']
  end

  def report_format_id
    Rails.application.config_for(:report)['format_id']
  end
end
