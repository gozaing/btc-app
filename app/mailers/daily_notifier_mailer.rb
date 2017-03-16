class DailyNotifierMailer < ApplicationMailer
  default from: "#{ENV['MAIL_FROM']}"
  def notify(arg)

    subject = arg[:total_count]
    body    = ''

    mail(to: "#{ENV['MAIL_TO']}", subject: "#{subject}") do |format|
      format.text
    end
  end
end
