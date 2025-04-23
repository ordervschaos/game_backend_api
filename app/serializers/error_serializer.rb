class ErrorSerializer
  def self.serialize(errors)
    {
      errors: Array.wrap(errors).map do |error|
        if error.is_a?(Hash)
          error
        else
          { detail: error.to_s }
        end
      end
    }
  end
end 