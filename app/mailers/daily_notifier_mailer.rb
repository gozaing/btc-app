class DailyNotifierMailer < ApplicationMailer
  default from: "#{ENV['MAIL_FROM']}"
  def notify
    mail(to: "#{ENV['MAIL_TO']}", subject: 'Daily Report') do |format|
      format.text
    end
  end
end
