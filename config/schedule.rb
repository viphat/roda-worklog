require './app'
every :weekday, :at => '7:00 am' do
  App::Main.sendmail("/mailer/daily", nil)
end
