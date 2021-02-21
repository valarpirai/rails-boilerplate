class BaseWorker
  include Sidekiq::Worker

  def perform(args)
    # do something
  end
end
