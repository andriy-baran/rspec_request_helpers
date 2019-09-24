module RspecRequestHelpers
  module Helpers
    module ClassMethods
      def path(&block)
        let(:path, &block)
      end

      def params(&block)
        let(:params, &block)
      end

      def headers(&block)
        let(:headers, &block)
      end

      def response(&block)
        let(:expected_response, &block)
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def object(hash)
      OpenStruct.new(hash)
    end

    def parse_json(json_data)
      JSON.parse(json_data, symbolize_names: true)
    end

    def response_body
      response.body
    end

    def response_hash
      parse_json(response_body)
    end

    def response_objects
      JSON.parse(response_body, object_class: OpenStruct)
    end

    def assert_raw
      expect(response_body).to eq expected_response
    end

    def assert_object
      expect(response_objects).to have_attributes(expected_response)
    end

    def assert_hash
      expect(response_hash).to eq(expected_response)
    end

    def self.generate_helpers
      %i(get post put patch delete).each do |http_verb|
        define_method :"do_#{http_verb}" do
          is_not_json_get = (http_verb == :get || headers['Content-Type'] != 'application/json')
          params_require_normalization = Rails::VERSION::MAJOR < 4 && is_not_json_get
          normalized_params = params_require_normalization ? params : params.to_json
          if Rails::VERSION::MAJOR >= 5
            public_send(http_verb, path, params: normalized_params, headers: headers)
          else
            public_send(http_verb, path, normalized_params, headers)
          end
        end

        RspecRequestHelpers.configuration.content_types.each do |type, mime_type|
          RspecRequestHelpers.configuration.symbols_with_status_codes.each do |status, code|
            %i(raw hash object).each do |resp_assertion|
              define_method :"assert_#{code}_#{type}" do
                expect(response).to have_http_status(status)
                expect(response.content_type).to eq mime_type
              end

              define_method :"assert_#{code}_#{type}_#{resp_assertion}" do
                public_send(:"assert_#{code}_#{type}")
                public_send(:"assert_#{resp_assertion}")
              end

              define_method :"do_#{http_verb}_and_assert_#{code}_#{type}_#{resp_assertion}" do
                public_send(:"do_#{http_verb}")
                public_send(:"assert_#{code}_#{type}_#{resp_assertion}")
              end
            end
          end
        end
      end
    end

    class << self
      alias_method :regenerate_helpers, :generate_helpers
    end
  end
end
