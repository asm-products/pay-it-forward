json.pledge_form do
  json.extract! @pledge_form, :amount, :tip_percentage, :name, :email, :charity_id, :referrer_id
  json.authenticity_token form_authenticity_token
end