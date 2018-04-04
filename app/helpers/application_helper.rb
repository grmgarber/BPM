module ApplicationHelper
  def errors_for(model, attr)
    raw("<div class='attribute-error'>#{model.errors[attr].join(', ')}</div>")
  end
end
