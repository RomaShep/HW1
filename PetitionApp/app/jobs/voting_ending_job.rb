class VotingEndingJob < ActiveJob::Base
  queue_as :default

  def perform
    # Do something later
    puts "Mail notification"
    Petition.all.each do |petition|
      if petition.expired? and !petition.old?
        if petition.petition_vin?
          UserMailer.petition_done(petition).deliver_now
          UserMailer.petition_admin(petition).deliver_now
        else
          UserMailer.petition_lost(petition).deliver_now
        end
      end
    end
  end

end
