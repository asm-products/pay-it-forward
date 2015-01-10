task enqueue_capture_pledge_jobs: :environment do
  puts 'starting enqueue_capture_pledge_jobs task'
  
  pledges = Pledge.where('expiration < ?', DateTime.now)
  pledges.find_each do |pledge|
    CapturePledgeJob.perform_later(pledge)
  end
  
  puts "enqueued #{pledges.count} to be captured"
end