module Retryable
  extend ActiveSupport::Concern

  DEFAULT_MAX_RETRIES = 7
  DEFAULT_INITIAL_WAIT = 1

  class_methods do
    def with_retries(max_retries: DEFAULT_MAX_RETRIES, initial_wait: DEFAULT_INITIAL_WAIT, logger: Rails.logger)
      @retry_config = { max_retries: max_retries, initial_wait: initial_wait, logger: logger }
      self
    end
  end

  def retry_with_exponential_backoff(error_classes:, context: nil)
    @retries ||= 0
    max_retries = self.class.instance_variable_get(:@retry_config)&.fetch(:max_retries, DEFAULT_MAX_RETRIES)
    initial_wait = self.class.instance_variable_get(:@retry_config)&.fetch(:initial_wait, DEFAULT_INITIAL_WAIT)
    logger = self.class.instance_variable_get(:@retry_config)&.fetch(:logger, Rails.logger)

    begin
      yield
    rescue *error_classes => e
      if @retries < max_retries
        @retries += 1
        wait_time = initial_wait * (2 ** (@retries - 1)) # exponential backoff
        logger.warn("#{context || 'Operation'} failed. Retry #{@retries}/#{max_retries} after #{wait_time}s. Error: #{e.message}")
        sleep(wait_time)
        retry
      else
        logger.error("#{context || 'Operation'} failed after #{max_retries} retries. Error: #{e.message}")
        false
      end
    end
  end
end 