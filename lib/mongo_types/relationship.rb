module Relationship
  module InstanceMethods
  end

  module ClassMethods
    def habtm(this_model, that_model, options = {})
      glue_model = options.has_key?(:glue_model) ? options[:glue_model] : [this_model, that_model].map { |m| Private.single(m).to_s }.sort.join('_')
      define_method Private.plural(that_model) do
        @those_models ||= Private.klass(glue_model).send("#{Private.plural(that_model)}_for", self.id)
      end

      save_callback = "save_#{Private.plural(glue_model)}"

      define_method save_callback do
        @those_models ||= []
        @those_models.each { |om| Private.klass(glue_model).first_or_create(Private.id_key(this_model) => self.id, Private.id_key(that_model) => om.id) }
      end

      self.after_save save_callback
    end

    def habtm_glue(model_a, model_b, options = {})
      {
        model_a => model_b,
        model_b => model_a
      }.each do |this_model, that_model|
        key Private.id_key(this_model), BSON::ObjectId, :required => true

        define_method this_model do
          Private.klass(this_model).find(self.send(Private.id_key(this_model)))
        end

        define_method "#{this_model}=" do |new_model|
          self.send "#{Private.id_key(this_model)}=", new_model.id
          new_model
        end

        this_model_for = lambda { |that_model_id| all(Private.id_key(that_model) => that_model_id).map { |tagging| tagging.send(this_model) } }
        self.class.send(:define_method, "#{Private.plural(this_model)}_for", this_model_for)
      end
    end
  end

  module Private
    def self.single(model_name)
      model_name.to_s.singularize.to_sym
    end

    def self.plural(model_name)
      model_name.to_s.pluralize.to_sym
    end

    def self.id_key(model_name)
      "#{single(model_name)}_id".to_sym
    end

    def self.klass(model_name)
      single(model_name).to_s.camelize.constantize
    end
  end

  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end
end
