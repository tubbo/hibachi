module Hibachi
  class Job < ActiveJob::Base
    def perform(model)
      Hibachi.run_chef model.recipe
    end
  end
end
