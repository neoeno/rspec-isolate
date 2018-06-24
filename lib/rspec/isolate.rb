require "rspec/isolate/version"
require "rspec/isolate/throw_on_call"
require "rspec/isolate/warn_on_call"
require "rspec/isolate/constant_replacer"
require "rspec/core"

RSpec.configure do |config|
  config.around :example, :throw_on_call do |example|
    klass_constants = example.metadata[:throw_on_call]
    ConstantReplacer.replace(klass_constants, &ThrowOnCall.method(:new))
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
