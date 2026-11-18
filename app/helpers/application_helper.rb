module ApplicationHelper
  def application_status_label(application)
    { "pending" => "未承認", "approved" => "承認済み", "rejected" => "見送り" }.fetch(application.status)
  end
end
