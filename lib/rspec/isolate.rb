require "rspec/isolate/version"
require "rspec/isolate/error_on_call"
require "rspec/isolate/warn_on_call"
require "rspec/isolate/constant_replacer"
require "rspec/core"

RSpec.configure do |config|
  config.around :example, :error_on_call do |example|
    klass_constants = example.metadata[:error_on_call]
    ConstantReplacer.replace(klass_constants, &ErrorOnCall.method(:new))
    example.run
    ConstantReplacer.replace(klass_constants, &:itself)
  end

  config.around :example, :warn_on_call do |example|
    klass_constants = example.metadata[:warn_on_call]
    ConstantReplacer.replace(klass_constants, &WarnOnCall.method(:new))
    example.run
    ConstantReplacer.replace(klass_constants, &:itself)
  end
end
