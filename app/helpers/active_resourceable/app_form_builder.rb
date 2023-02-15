class ActiveResourceable::AppFormBuilder < ActionView::Helpers::FormBuilder

  Dir.glob("#{Rails.root}/app/views/app_form_builder/*").each do |view_path|
    field = view_path.split('/')[-1].split('.')[0][1..-1]
    define_method(field) do |*args, **kwargs, &block|
      @template.render partial: "/app_form_builder/#{field}", locals: { args: args, kwargs: kwargs, block: block, field: self }
    end
  end

  def is_required method
    @object.class.validators_on(method).any? do |validator|
      validator.class == ActiveRecord::Validations::PresenceValidator
    end unless @object.nil?
  end

  def should_display_input? method, access_object
    @object.accessable_fields.any? { |attr| attr.is_a?(Hash) ? attr.keys.first.to_s == "#{method}_attributes" : attr == method }
  end
end
