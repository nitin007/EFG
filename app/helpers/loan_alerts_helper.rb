module LoanAlertsHelper
  def loan_alerts_priority(priority)
    return if priority.blank?
    secondary_class_name = case priority
    when "high"
      'label-danger'
    when "medium"
      'label-warning'
    when "low"
      'label-success'
    end

    if params[:priority]
      content_tag(:div, "#{params[:priority].titleize} Priority", class: "label #{secondary_class_name}")
    end
  end

  def other_alert_links(priority)
    selected_button_class = 'btn btn-info'
    unselected_button_class = 'btn btn-default'
    all_links_class = priority.blank? ? selected_button_class : unselected_button_class

    links = [
      link_to("All Loan Alerts", url_for, class: all_links_class)
    ]

    %w(high medium low).each_with_object(links) do |p, memo|
      button_class = p == priority ? selected_button_class : unselected_button_class
      memo << link_to("#{p.titleize} Priority Alerts", url_for(priority: p), class: button_class)
    end

    links.join.html_safe
  end

end
