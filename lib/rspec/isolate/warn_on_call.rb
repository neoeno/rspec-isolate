class WarnOnCall
  def initialize(klass)
    @klass = klass
  end

  def method_missing(name, *args)
    warn "Method :#{name} called on isolated class #{@klass.name}"
    @klass.public_send(name, *args)
  end
end
