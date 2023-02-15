require "rails/engine"
require "pagy"
require "procore-sift"

module ActiveResourceable
  class Engine < ::Rails::Engine
    isolate_namespace ActiveResourceable
    engine_name "active_resourceable"
    config.eager_load_namespaces << ActiveResourceable
    config.active_resourceable = ActiveSupport::OrderedOptions.new
    config.autoload_once_paths = %W(
      #{root}/app/channels
      #{root}/app/controllers
      #{root}/app/controllers/concerns
      #{root}/app/helpers
      #{root}/app/models
      #{root}/app/models/concerns
      #{root}/app/jobs
    )
    
    initializer "active_resourceable.resourceable", before: :load_config_initializers do
      ActiveSupport.on_load(:action_controller_base) do
        default_form_builder ActiveResourceable::AppFormBuilder
        include Pagy::Backend
        include Sift
        include ActiveResourceable::Resourceable
      end
    end

    initializer "active_resourceable.models_concerns" do
      ActiveSupport.on_load(:active_record) do
        include ActiveResourceable::Governable
        include ActiveResourceable::Asyncable
        scope :unpaginate, ->() {
          offset(nil).limit(nil)
        }
      end
    end
  end
end
