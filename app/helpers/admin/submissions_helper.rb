module Admin::SubmissionsHelper
  JUDGE_STATUS = %w[WJ WA AC].freeze

  def judge_status_badge(submission)
    status_name = JUDGE_STATUS[submission.judge_status_before_type_cast]
    content_tag(:span, status_name, class: "submissions--judgeStatusBadge__#{status_name}")
  end
end
