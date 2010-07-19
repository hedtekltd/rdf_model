module RdfModel::Associations
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def linked_to(model = nil, options = {})
      @linked_models ||= {}
      if model
        raise "No :with link given" unless options.has_key? :with
        @linked_models[options[:with]] = model
      end
      return @linked_models
    end
  end
end