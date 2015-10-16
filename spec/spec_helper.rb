$: << '../'
Dir.glob('lib/**/*.rb').each {|f| require f}

RSpec.configure do |config|
  config.tty = true

  config.formatter = 'Fuubar'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
