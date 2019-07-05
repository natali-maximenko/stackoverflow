RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  FactoryBot::SyntaxRunner.class_eval do
    include ActionDispatch::TestProcess
  end
end
