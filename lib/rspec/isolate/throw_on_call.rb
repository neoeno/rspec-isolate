class ThrowOnCall
  def initialize(klass)
    @klass = klass
  end

  def method_missing(name, *args)
    raise IsolationError.new("Method :#{name} called on isolated class #{@klass.name}")
  end
end

class IsolationError < StandardError; end
