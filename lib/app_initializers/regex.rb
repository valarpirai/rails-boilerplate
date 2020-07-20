# frozen_string_literal: true

module Regex
  EMAIL_VALIDATOR = /\A[-A-Z0-9.'’_&%=~+]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2,15})\z/i
  EMAIL_REGEX = /(\b[-a-zA-Z0-9.'’_&%=~+]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,15}\b)/
  EMAIL_SCANNER = /\b[-a-zA-Z0-9.'’_&%=~+]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,15}\b/
end
