require 'html_converter'
require 'pry'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end


