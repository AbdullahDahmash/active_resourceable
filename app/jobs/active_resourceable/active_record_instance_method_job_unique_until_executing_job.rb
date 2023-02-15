class ActiveResourceable::ActiveRecordInstanceMethodJobUniqueUntilExecutingJob < ApplicationJob
  queue_as :default
  unique :until_executing, on_conflict: ->(job) {}

  def perform(instance, method, *args)
    instance.send "#{method}_sync", *args
  end
end
