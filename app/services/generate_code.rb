class GenerateCode < ApplicationService
  def initialize(code_byte)
    @code_byte = code_byte
  end

  def call
    code = SecureRandom.urlsafe_base64(@code_byte)
    while Url.exists?(short_code: code)
      code = SecureRandom.urlsafe_base64(@code_byte)
    end

    code
  end
end
