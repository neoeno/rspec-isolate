require "rspec/isolate/version"
require "rspec/isolate/throw_on_call"
require "rspec/isolate/warn_on_call"
require "rspec/core"

RSpec.configure do |config|
  config.around :example, :throw_on_call do |example|
    isolate_classes = example.metadata[:throw_on_call]
    isolate_classes.each do |klass|
      get_module(klass.name).send(:remove_const, get_class(klass.name))
      get_module(klass.name).const_set(get_class(klass.name), ThrowOnCall.new(klass))
    end
    example.run
    isolate_classes.each do |klass|
      get_module(klass.name).send(:remove_const, get_class(klass.name))
      get_module(klass.name).const_set(get_class(klass.name), klass)
    end
  end

  config.around :example, :warn_on_call do |example|
    isolate_classes = example.metadata[:warn_on_call]
    isolate_classes.each do |klass|
      get_module(klass.name).send(:remove_const, get_class(klass.name))
      get_module(klass.name).const_set(get_class(klass.name), WarnOnCall.new(klass))
    end
    example.run
    isolate_classes.each do |klass|
      get_module(klass.name).send(:remove_const, get_class(klass.name))
      get_module(klass.name).const_set(get_class(klass.name), klass)
    end
  end

  def get_module(klass_name, scope = Object)
    return scope unless klass_name.include? "::"
    parent_scope_name = klass_name[0...klass_name.index('::')]
    parent_scope = scope.const_get(parent_scope_name)
    remaining_module_path = klass_name[(klass_name.index("::") + 2)..-1]
    get_module(remaining_module_path, parent_scope)
  end

  def get_class(klass_name)
    return klass_name unless klass_name.include? "::"
    klass_name[(klass_name.rindex("::") + 2)..-1]
  end
end
