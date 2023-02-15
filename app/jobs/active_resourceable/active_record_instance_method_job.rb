class ActiveResourceable::ActiveRecordInstanceMethodJob < ApplicationJob
  queue_as :default

  def perform(instance, method, *args)
    instance.send "#{method}_sync", *args
  end
end
