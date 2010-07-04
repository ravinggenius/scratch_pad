module Relationship
  def habtm(this_model, that_model, glue_model, options = {})
    define_method plural(that_model) do
      @those_models ||= klass(glue_model).send("#{plural(that_model)}_for".to_sym, self.id)
    end

    define_method "save_#{plural(glue_model)}".to_sym do
      @those_models ||= []
      @those_models.each { |om| klass(glue_model).first_or_create(id_key(this_model) => self.id, id_key(that_model) => om.id) }
    end
  end

  def habtm_glue(model_a, model_b, options = {})
    @models ||= {}

    {
      model_a => model_b,
      model_b => model_a
    }.each do |this_model, that_model|
      define_method this_model do
        @models[this_model] ||= klass(this_model).find(self.send(id_key(this_model)))
      end

      define_method "#{this_model}=".to_sym, new_model do
        self.send "#{id_key(this_model)}=", new_model.id
        @models[this_model] = new_model
      end

      define_class_method "#{plural(this_model)}_for".to_sym, that_model_id do
        all(id_key(that_model) => that_model_id.to_s).map { |tagging| tagging.send(this_model) }
      end
    end
  end

  private

  def single(model_name)
    model_name.to_s.singularize.to_sym
  end

  def plural(model_name)
    model_name.to_s.pluralize.to_sym
  end

  def id_key(model_name)
    "#{single(model_name)}_id".to_sym
  end

  def klass(model_name)
    single(model_name).to_s.capitalize.constantize
  end
end