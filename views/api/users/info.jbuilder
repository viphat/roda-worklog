json.user do
  json.id @current_user.id
  json.name @current_user.name
  json.email @current_user.email
  json.team @current_user.team.name
end