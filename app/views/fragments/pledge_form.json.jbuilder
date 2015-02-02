json.pledge_form do
  json.authenticity_token form_authenticity_token
  json.charity_id 1
  json.amount 2000
  json.tip_percentage 5

  if current_user.present?
    json.name @pledge_form.name || current_user.name
    json.email @pledge_form.email || current_user.email
  end
end