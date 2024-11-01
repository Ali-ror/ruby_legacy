require 'simple_form'

SimpleForm::FormBuilder.class_eval do
  def link_to_add( name, association, html_options = {} )
    @fields ||= {}    
    @template.after_nested_form(association) do
      model_object = object.class.reflect_on_association(association).klass.new
      output = %Q[<div id="#{association}_fields_blueprint" style="display: none">].html_safe
      output << simple_fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
      output.safe_concat('</div>')
      output
    end
    
    html_options["data-association"] = association
    if html_options.has_key?( :class )
      html_options[:class] = html_options[:class] + " add_nested_fields"
    else
      html_options[:class] = "add_nested_fields"
    end
    @template.link_to(name, "javascript:void(0)", html_options )
  end

  def link_to_remove(name)
    hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
  end

  def fields_for_with_nested_attributes(association, args, block)    
    @fields ||= {}
    @fields[association] = block
    super
  end

  def fields_for_nested_model(name, association, args, block)
    output = '<div class="fields">'.html_safe
    output << super
    output.safe_concat('</div>')
    output
  end

end

SimpleForm::ActionViewExtensions::FormHelper.class_eval do
  
  def after_nested_form(association, &block)
    @after_nested_form_callbacks ||= {}
    @after_nested_form_callbacks[association] = block
  end

  def simple_nested_form_for(*args, &block)
    output = simple_form_for(*args, &block)
    @after_nested_form_callbacks ||= {}
    fields = @after_nested_form_callbacks.map do |key, callback|
      callback.call
    end
    output << fields.join(" ").html_safe
  end

end
