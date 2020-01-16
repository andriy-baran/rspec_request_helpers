#!/usr/bin/ruby
# @Author: Andrii Baran
# @Date:   2019-12-09 15:05:38
# @Last Modified by:   Andrii Baran
# @Last Modified time: 2020-01-16 12:17:37

module RspecRequestHelpers
  class Configuration
    attr_accessor :content_types, :status_codes

    def initialize
      @content_types = { json: 'application/json' }
      @status_codes  = [404, 401, 422, 200, 201]
    end

    def symbols_with_status_codes
      status_codes.inject({}) do |hash, code|
        hash[STATUS_CODE_TO_SYMBOL[code]] = code
        hash
      end
    end
  end
end
