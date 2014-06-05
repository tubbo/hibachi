module Hibachi
  # Thrown when `Hibachi::Job` is called, but `ActiveJob::Base` was not
  # defined. Prevents a possibly harder-to-diagnose error.
  class InstallActiveJobError < StandardError
    def initialize
      @message = %{
        You must install ActiveJob to run Hibachi in the background..

        <https://github.com/rails/activejob>
      }
    end
  end
end
