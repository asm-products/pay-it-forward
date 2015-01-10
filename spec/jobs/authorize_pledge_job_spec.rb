require 'rails_helper'

RSpec.describe AuthorizePledgeJob, type: :job do
  it 'returns unless created?' do
    pledge = create(:pledge, :authorized)
    expect { AuthorizePledgeJob.perform_now(pledge) }.not_to change { pledge.state }
  end

  it 'authorizes the pledge' do
    pledge = create(:pledge)
    expect { AuthorizePledgeJob.perform_now(pledge) }.to change { pledge.state }.from('created').to('authorized')
  end
end
