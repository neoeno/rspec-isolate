class ConstantReplacer
  class << self
    def replace(klass_constants, &block)
      klass_constants.each do |klass|
        get_module(klass).send(:remove_const, get_class_name(klass))
        get_module(klass).const_set(get_class_name(klass), block.call(klass))
      end
    end

    private

    def get_module(klass_constant)
      get_module_names(klass_constant).reduce(Object, :const_get)
    end

    def get_module_names(klass_constant)
      get_constant_components(klass_constant)[0...-1]
    end

    def get_class_name(klass_constant)
      get_constant_components(klass_constant).last
    end

    def get_constant_components(klass_constant)
      klass_constant.name.split("::")
    end
  end
end
