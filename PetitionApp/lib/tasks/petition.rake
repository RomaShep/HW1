namespace :petitions do
  
  desc "Email notification"
  task email_notification: :environment do
    VotingEndingJob.perform_later
  end
end