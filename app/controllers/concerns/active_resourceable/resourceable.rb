module ActiveResourceable::Resourceable
  extend ActiveSupport::Concern
  included do
  end

  class_methods do

    def resource_model name, **opt

      model_class = name.to_s.classify.constantize if name.is_a? Symbol
      model_class = name.classify.constantize if name.is_a? String
      model_class = name if name.is_a? Class and name.ancestors.include? ActiveRecord::Base
      raise "Unable to identify resource model" if model_class.nil?
      model_name = model_class.name.singularize.downcase

      filter_set = opt[:filter_set]

      filter_set.each do |filter_attr, filter_opt|
        filter_on filter_attr, **filter_opt
      end unless filter_set.nil?

      sort_set = opt[:sort_set]

      sort_set.each do |sort_attr, sort_opt|
        sort_on sort_attr, **sort_opt
      end unless sort_set.nil?

      define_method("list_#{model_name.pluralize}") do
        @pagy, collection = pagy(filtrate(model_class.readable_for(access_object)))
        instance_variable_set :"@#{model_name.pluralize}", collection
      end

      define_method("show_#{model_name}") do
        instance = model_class.readable_for(access_object).find(params[:id])
        instance.access_object = access_object
        instance_variable_set :"@#{model_name}", instance
      end

      define_method("new_#{model_name}") do
        instance = model_class.new
        instance.access_object = access_object
        instance_variable_set :"@#{model_name}", instance
      end

      define_method("create_#{model_name}") do
        instance = model_class.new
        instance_variable_set :"@#{model_name}", instance
        instance.access_object = access_object
        instance.assign_attributes send("#{model_name}_params")
        instance.save
        render :new, status: :unprocessable_entity unless instance_variable_get(:"@#{model_name}").valid?
      end

      define_method("edit_#{model_name}") do
        instance = model_class.editable_for(access_object).find(params[:id])
        instance.access_object = access_object
        instance_variable_set :"@#{model_name}", instance
      end

      define_method("update_#{model_name}") do
        instance = model_class.editable_for(access_object).find(params[:id])
        instance.access_object = access_object
        instance_variable_set :"@#{model_name}", instance
        instance.assign_attributes send("#{model_name}_params")
        instance.save
        render :edit, status: :unprocessable_entity unless instance_variable_get(:"@#{model_name}").valid?
      end

      define_method("destroy_#{model_name}") do
        instance = model_class.deletable_for(access_object).find(params[:id])
        instance.access_object = access_object
        instance.destroy
        instance_variable_set :"@#{model_name}", instance
      end

      define_method("#{model_name}_params") do
        instance = instance_variable_get(:"@#{model_name}")
        fields = instance.accessable_fields
        send("#{model_name}_attrs", params.fetch(model_name, {}).permit(fields), fields)
      end

      alias_method "#{model_name}_args", "#{model_name}_params"

      define_method("#{model_name}_attrs") do |object_params, fields|
        (fields.include?(:user_id) and access_object.present?) ? object_params.merge(user_id: access_object.id) : object_params
      end

      define_method(:access_object) do
        @access.authenticated_user
      end unless method_defined? :access_object

      define_method(:filter_params) do
        params.fetch(:filters, {}).permit(*filter_set.keys)
      end

      define_method(:sort_params) do
        params.permit(:sort)
      end

      alias_method :user_object, :access_object

      before_action :"list_#{model_name.pluralize}", only: %i[index]
      before_action :"show_#{model_name}", only: %i[show]
      before_action :"new_#{model_name}", only: %i[new]
      before_action :"create_#{model_name}", only: %i[create]
      before_action :"edit_#{model_name}", only: %i[edit]
      before_action :"update_#{model_name}", only: %i[update]
      before_action :"destroy_#{model_name}", only: %i[destroy]

    end

  end
end
