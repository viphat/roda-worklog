require './app'
every :saturday, :at => '1:00 am' do
  App::Main.sendmail("/mailer/weekly", nil)
end
