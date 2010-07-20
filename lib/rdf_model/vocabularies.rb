module ::RdfModel::Vocabularies
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def vocabulary(vocab = nil)
      @vocabularies ||= {}
      if vocab
        vocab.each do |name, uri|
          @vocabularies[name] = Vocabulary.new(uri)
        end
      end
      @vocabularies.merge(superclass.respond_to?(:vocabulary) ? superclass.vocabulary : {})
    end

    def method_missing(method, *args, &block)
      return get_vocabulary(vocabulary_name(method)) if is_vocabulary?(method)
      super(method, *args, &block)
    end

    def respond_to?(name)
      return is_vocabulary?(name) || super(name)
    end

    private

    def is_vocabulary?(name)
      (v = vocabulary_name(name)) && has_vocabulary(v)
    end

    def vocabulary_name(full_name)
      (full_name.to_s =~ /^vocab_(.+)$/) && $1
    end

    def get_vocabulary(vocab_name)
      vocabulary[vocab_name.to_sym]
    end

    def has_vocabulary(vocab_name)
      vocabulary.has_key? vocab_name.to_sym
    end
  end

  class Vocabulary
    attr_accessor :uri

    def method_missing(method, *args, &block)
      return uri + method.to_s
    end

    def initialize(uri)
      self.uri = uri
    end
  end
end