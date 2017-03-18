class Tasks::Result
  def self.execute

    # get result
    hash = ActiveRecord::Base.connection.select_all(
      "select
  count(*) total_count
,(select count(diff) from results where created_at > '#{1.days.ago.beginning_of_day}' and created_at < '#{Time.zone.now.beginning_of_day}') day_count
 ,(select sum(diff) from results where created_at > '#{1.days.ago.beginning_of_day}' and created_at < '#{Time.zone.now.beginning_of_day}') day_sum
 ,(select sum(diff) from results where diff < 0 and created_at > '#{1.days.ago.beginning_of_day}' and created_at < '#{Time.zone.now.beginning_of_day}') day_lose
 ,(select count(diff) from results where diff < 0 and created_at > '#{1.days.ago.beginning_of_day}' and created_at < '#{Time.zone.now.beginning_of_day}') day_lose_count
 ,(select sum(diff) from results where diff >= 0 and created_at > '#{1.days.ago.beginning_of_day}' and created_at < '#{Time.zone.now.beginning_of_day}') day_win
 ,(select count(diff) from results where diff >= 0 and created_at > '#{1.days.ago.beginning_of_day}' and created_at < '#{Time.zone.now.beginning_of_day}') day_win_count
from results").to_hash

    total_count    = hash[0]["total_count"]
    day_count      = hash[0]["day_count"]
    day_sum        = hash[0]["day_sum"]
    day_lose       = hash[0]["day_lose"]
    day_lose_count = hash[0]["day_lose_count"]
    day_win        = hash[0]["day_win"]
    day_win_count  = hash[0]["day_win_count"]

    # send mail of result
    # TODO: ActionMailer の template に上の変数を展開
    mail_content = {
          total_count:    total_count,
          day_count:      day_count,
          day_sum:        day_sum,
          day_lose:       day_lose,
          day_lose_count: day_lose_count,
          day_win:        day_win,
          day_win_count:  day_win_count
           }

    DailyNotifierMailer.notify(mail_content).deliver

  end
end

