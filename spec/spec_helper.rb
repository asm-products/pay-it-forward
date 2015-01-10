require 'vcr'
require 'sidekiq/testing'

ENV['STRIPE_KEY'] ||= '<STRIPE_KEY>'
ENV['STRIPE_SECRET'] ||= '<STRIPE_SECRET>'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_hosts 'codeclimate.com'

  c.filter_sensitive_data('<TWITTER_KEY>')    { ENV['TWITTER_KEY'] }
  c.filter_sensitive_data('<TWITTER_SECRET>') { ENV['TWITTER_SECRET'] }

  c.filter_sensitive_data('<FACEBOOK_KEY>')    { ENV['FACEBOOK_KEY'] }
  c.filter_sensitive_data('<FACEBOOK_SECRET>') { ENV['FACEBOOK_SECRET'] }

  c.filter_sensitive_data('<AWS_ACCESS_KEY_ID>')     { ENV['AWS_ACCESS_KEY_ID'] }
  c.filter_sensitive_data('<AWS_SECRET_ACCESS_KEY>') { ENV['AWS_SECRET_ACCESS_KEY'] }

  c.filter_sensitive_data('<STRIPE_KEY>')    { ENV['STRIPE_KEY'] }
  c.filter_sensitive_data('<STRIPE_SECRET>') { ENV['STRIPE_SECRET'] }
end

RSpec.configure do |config|
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  # config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/[^\w\/]+/, '_')
      VCR.use_cassette(name, options, &example)
    end
  end

  config.before(:each) do |_example_method|
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all
  end

  config.around(:each) do |example|
    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!(&example)
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!(&example)
    elsif example.metadata[:type] == :feature
      Sidekiq::Testing.inline!(&example)
    else
      Sidekiq::Testing.fake!(&example)
    end
  end
end
