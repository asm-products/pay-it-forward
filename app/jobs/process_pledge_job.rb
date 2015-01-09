class ProcessPledgeJob < ActiveJob::Base
  queue_as :default

  def perform(pledge)
    return unless pledge.authorized?
    return ProcessPledgeJob.set(wait_until: pledge.expiration + 1.second).perform_later(@pledge) unless pledge.expired?
    CapturePledgeJob.perform_later(pledge)
  end
end
