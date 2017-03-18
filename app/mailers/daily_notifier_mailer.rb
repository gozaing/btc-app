class DailyNotifierMailer < ApplicationMailer
  default from: "#{ENV['MAIL_FROM']}"
  def notify(arg)

    subject = "result #{1.days.ago.beginning_of_day}"
    body    = "
total_count    => #{arg[:total_count]} \n
day_count      => #{arg[:day_count]} \n
day_sum        => #{arg[:day_sum]} \n
day_lose       => #{arg[:day_lose]} \n
day_lose_count => #{arg[:day_lose_count]} \n
day_win        => #{arg[:day_win]} \n
day_win_count  => #{arg[:day_win_count]}
"

    mail(to: "#{ENV['MAIL_TO']}",
         subject: "#{subject}",
         body:    "#{body}",
         condition_type: "text/plain"
        )
    # not use template
    # TODO: need to search how to embed code in format.text
    #mail(to: "#{ENV['MAIL_TO']}", subject: "#{subject}") do |format|
    #  format.text
    #end
  end
end
