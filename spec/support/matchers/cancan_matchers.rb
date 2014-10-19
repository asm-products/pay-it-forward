# Custom rspec matcher for testing CanCan abilities.
# Originally inspired by https://github.com/ryanb/cancan/wiki/Testing-Abilities
#
# Usage:
#   should have_abilities(:create, Post.new)
#   should have_abilities([:read, :update], post)
#   should have_abilities({manage: false, destroy: true}, post)
#   should have_abilities({create: false}, Post.new)
#   should not_have_abilities(:update, post)
#   should not_have_abilities([:update, :destroy], post)
#
# WARNING: never use "should_not have_abilities" or you may get false positives due to
# whitelisting/blacklisting issues. Use "should not_have_abilities" instead.

RSpec::Matchers.define :have_abilities do |actions, obj|
  include HaveAbilitiesMixin

  match do |ability|
    verify_ability_type(ability)
    @expected_hash = build_expected_hash(actions, default_expectation: true)
    @obj = obj
    @actual_hash = {}
    @expected_hash.each do |action, _|
      @actual_hash[action] = ability.can?(action, obj)
    end
    @actual_hash == @expected_hash
  end

  description do
    obj_name = @obj.class.name
    obj_name = @obj.to_s.capitalize if [Class, Module, Symbol].include?(@obj.class)
    "have abilities #{@expected_hash.keys.join(', ')} on #{obj_name}"
  end

  failure_message do |_ability|
    obj_name = @obj.class.name
    obj_name = @obj.to_s.capitalize if [Class, Module, Symbol].include?(@obj.class)
    message = (
      "expected user to have abilities: #{@expected_hash} for " \
      "#{obj_name}, but got #{@actual_hash}"
    )
  end
end

RSpec::Matchers.define :not_have_abilities do |actions, obj|
  include HaveAbilitiesMixin

  match do |ability|
    verify_ability_type(ability)
    if actions.is_a?(Hash)
      fail ArgumentError.new(
        'You cannot pass a hash to not_have_abilities. Use have_abilities instead.')
    end
    @expected_hash = build_expected_hash(actions, default_expectation: false)
    @obj = obj
    @actual_hash = {}
    @expected_hash.each do |action, _|
      @actual_hash[action] = ability.can?(action, obj)
    end
    @actual_hash == @expected_hash
  end

  description do
    obj_name = @obj.class.name
    obj_name = @obj.to_s.capitalize if [Class, Module, Symbol].include?(@obj.class)
    "not have abilities #{@expected_hash.keys.join(', ')} on #{obj_name}" if @expected_hash.present?
  end

  failure_message do |_ability|
    obj_name = @obj.class.name
    obj_name = @obj.to_s.capitalize if [Class, Module, Symbol].include?(@obj.class)
    message = (
      "expected user NOT to have abilities #{@expected_hash.keys.join(', ')} for " \
      "#{obj_name}, but got #{@actual_hash}"
    )
  end
end

module HaveAbilitiesMixin
  def build_expected_hash(actions, default_expectation:)
    return actions if actions.is_a?(Hash)
    expected_hash = {}
    if actions.is_a?(Array)
      # If given an array like [:create, read] build a hash like:
      # {create: default_expectation, read: default_expectation}
      actions.each { |action| expected_hash[action] = default_expectation }
    elsif actions.is_a?(Symbol)
      # Build a hash if it's just a symbol.
      expected_hash = { actions => default_expectation }
    end
    expected_hash
  end

  def verify_ability_type(ability)
    unless ability.class.ancestors.include?(CanCan::Ability)
      fail TypeError.new("subject must mixin CanCan::Ability, got a #{ability.class.name} class.")
    end
  end
end

#class TestingAbility
#  include CanCan::Ability
#
#  def initialize(_user)
#    can :read, User
#    can :comment, User
#    cannot :destroy, User
#  end
#end

#describe 'CanCan custom RSpec::Matchers' do
#  subject(:ability) { TestingAbility.new(user) }
#  let(:user) { create(:user) }
#  let(:other_user) { create(:user) }
#
#  it { should have_abilities(:read, other_user) }
#  it { should have_abilities(:comment, other_user) }
#  it { should have_abilities({ destroy: false }, other_user) }
#  it { should have_abilities([:read], other_user) }
#  it { should have_abilities([:read, :comment], other_user) }
#  it { should have_abilities({ read: true }, other_user) }
#  it { should have_abilities({ read: true, comment: true }, other_user) }
#  it { should have_abilities({ read: true, destroy: false }, other_user) }
#  it { should have_abilities({ read: true, comment: true, destroy: false }, other_user) }
#  it { should not_have_abilities(:destroy, other_user) }
#  it { should not_have_abilities([:destroy], other_user) }
#
#  # These should all expect failure intentionally, to catch false positives.
#  let(:expected_error) { RSpec::Expectations::ExpectationNotMetError }
#  it { expect { should have_abilities(:destroy, other_user) }.to raise_error(expected_error) }
#  it { expect { should have_abilities([:destroy], other_user) }.to raise_error(expected_error) }
#  it { expect { should have_abilities([:read, :destroy], other_user) }.to raise_error(expected_error) }
#  it { expect { should have_abilities({ read: true, destroy: true }, other_user) }.to raise_error(expected_error) }
#  it { expect { should have_abilities({ read: false, destroy: false }, other_user) }.to raise_error(expected_error) }
#  it { expect { should have_abilities({ read: false, destroy: true }, other_user) }.to raise_error(expected_error) }
#  it { expect { should not_have_abilities([:read, :destroy], other_user) }.to raise_error(expected_error) }
#  it { expect { should not_have_abilities({ destroy: false }, other_user) }.to raise_error(ArgumentError) }
#
#  # Never use should_not with have_abilities.
#end

