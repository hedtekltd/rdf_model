module RdfModel::Associations
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      alias :process_attribute_value_without_associations :process_attribute_value
      alias :process_attribute_value :process_attribute_value_with_associations
    end
  end

  def process_attribute_value_with_associations(name, value)
    if linked_model = self.class.linked_to[name]
      @linked_model_instances ||= {}
      @linked_model_instances[name] = linked_model.find_by_uri(value[0]) unless @linked_model_instances[name]
      return @linked_model_instances[name]
    end
    process_attribute_value_without_associations(name, value)
  end

  private

  def process_inverse_model_link(predicate)
    @inverse_linked_model_instances ||= {}
    unless @inverse_linked_model_instances[predicate]
      model = self.class.linked_from[predicate]
      @inverse_linked_model_instances[predicate] = model.find_by_predicate(predicate, uri)
    end
    return @inverse_linked_model_instances[predicate]
  end

  public

  module ClassMethods
    def linked_to(model = nil, options = {})
      @linked_models ||= {}
      if model
        raise "No :with link given" unless options.has_key? :with
        @linked_models[options[:with]] = model
      end
      return @linked_models.merge(superclass.respond_to?(:linked_to) ? superclass.linked_to : {})
    end

    def linked_from(model = nil, options = {})
      @inverse_linked_models ||= {}
      if model
        raise "No :with link given" unless options.has_key? :with
        raise "No :as name given" unless options.has_key? :as
        @inverse_linked_models[options[:with]] = model
        define_method(options[:as]) {process_inverse_model_link(options[:with])}
      end
      return @inverse_linked_models.merge(superclass.respond_to?(:linked_from) ? superclass.linked_from : {})
    end
  end
end