class CapturePledgeJob < ActiveJob::Base
  queue_as :capture_pledge

  def perform(pledge)
    # While this job should not be enqueued unless the pledge is capture-able, there
    # is a chance that this job will be enqueued multiple times. This catch protects
    # from that case.
    return unless pledge.authorized?

    pledge.capture!
  end
end
