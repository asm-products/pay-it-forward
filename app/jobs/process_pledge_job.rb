class ProcessPledgeJob < ActiveJob::Base
  queue_as :default

  def perform(pledge)
    
    return unless pledge.authorized?
    
    return ProcessPledgeJob.set(wait_until: pledge.expiration) unless pledge.expired?
    
  end
end
