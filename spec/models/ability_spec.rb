require 'rails_helper'

RSpec.describe Ability, type: :model do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  subject(:ability) { Ability.new(user) }

  it { should have_abilities(:read, user) }
  it { should have_abilities(:read, other_user) }

  it { should have_abilities(:update, user) }
  it { should not_have_abilities(:update, other_user) }

  it { should not_have_abilities(:create, User) }
  it { should not_have_abilities(:create, User) }

  it { should not_have_abilities(:destroy, user) }
  it { should not_have_abilities(:destroy, other_user) }

end
