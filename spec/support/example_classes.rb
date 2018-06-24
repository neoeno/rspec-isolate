class ParentClass
  def initialize(child = ChildClass.new)
    @child = child
  end

  def parent_hello
    @child.child_hello
  end
end

class ParentClassWithNesting
  def initialize(child = NestingModule::NestingModuleTwo::ChildClass.new)
    @child = child
  end

  def parent_hello
    @child.child_hello
  end
end

class ChildClass
  def child_hello
    "hello"
  end
end

module NestingModule
  module NestingModuleTwo
    class ChildClass
      def child_hello
        "hello"
      end
    end
  end
end
