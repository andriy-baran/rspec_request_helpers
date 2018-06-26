RspecRequestHelpers.configure do |config|
  # Responces content type and shorthand as key
  # The key will be used for the generation of helpers names
  config.content_types = { json: 'application/json' }

  # Array of supported status codes
  config.status_codes  = [404, 401, 422, 200, 201, 403]
end
