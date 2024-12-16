class Url < ApplicationRecord
    validates :original_url, presence: true
    validates :short_code, presence: true
    validates_format_of :original_url, with: /(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})(\.[a-zA-Z0-9]{2,})?/,
                                        message: "must be a valid URL"


    before_validation :generate_shortcode, on: :create

    def generate_shortcode
        self.short_code ||= GenerateCode.call(5)
    end
end
