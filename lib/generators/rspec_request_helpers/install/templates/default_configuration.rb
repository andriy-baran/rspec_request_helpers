#!/usr/bin/ruby
# @Author: Andrii Baran
# @Date:   2019-12-09 15:05:38
# @Last Modified by:   Andrii Baran
# @Last Modified time: 2020-01-16 12:17:28

RspecRequestHelpers.configure do |config|
  # Responces content type and shorthand as key
  # The key will be used for the generation of helpers names
  config.content_types = { json: 'application/json' }

  # Array of supported status codes
  config.status_codes  = [404, 401, 422, 200, 201, 403]
end
