# Preview all emails at http://localhost:3000/rails/mailers/users_mailer
class UsersMailerPreview < ActionMailer::Preview
  
  def confirmation_instructions
    UsersMailer.confirmation_instructions(User.first, :confirmation_instructions)
  end

  def reset_password_instructions
    UsersMailer.reset_password_instructions(User.first, :reset_password_instructions)
  end

  def unlock_instructions
    UsersMailer.confirmation_instructions(User.first, :unlock_instructions)
  end
  
end
