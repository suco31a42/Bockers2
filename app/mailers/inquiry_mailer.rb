class InquiryMailer < ApplicationMailer
  @inquiry = inquiry
  mail(
    from: 'system@example.com',
    to:   'manager@example.com',
    subject: 'お問い合わせ通知'
  )
end
