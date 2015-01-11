require 'rails_helper'

RSpec.describe CapturePledgeJob, type: :job do
  it 'returns unless authorized?' do
    pledge = create(:pledge)
    expect { CapturePledgeJob.perform_now(pledge) }.not_to change { pledge.state }
  end

  it 'captures the pledge' do
    pledge = create(:pledge, :authorized)
    expect { CapturePledgeJob.perform_now(pledge) }.to change { pledge.state }.from('authorized').to('captured')
  end
end
