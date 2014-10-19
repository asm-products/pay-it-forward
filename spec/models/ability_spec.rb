require 'rails_helper'

RSpec.describe Ability, type: :model do

  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

end
