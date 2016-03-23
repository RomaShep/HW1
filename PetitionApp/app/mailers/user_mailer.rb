class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def petition_done(petition)
    @petition = petition
    @user = petition.user
    mail to: @user.email, subject: 'Ваша петиция набрала достаточное количество голосов'
  end

  def petition_lost(petition)
    @petition = petition
    @user = petition.user
    mail to: @user.email, subject: 'Ваша петиция НЕ набрала достаточное количество голосов'
  end

  def petition_admin(petition)
    @petition = petition
    mail to: 'admin@mail.com', subject: 'Петиция набрала достаточное количество голосов'
  end

end
