if defined? ActiveJob::Base
  module Hibachi
    class Job < ActiveJob::Base
      def perform(model)
        Hibachi.run_chef model.recipe
      end
    end
  end
else
  raise "You must install ActiveJob to background Chef runs (https://github.com/rails/activejob)"
end
