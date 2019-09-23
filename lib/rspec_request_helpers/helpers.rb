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

      def expected_response(&block)
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
      JSON.parse(response.body, symbolize_names: true)
    end

    def response_object
      OpenStruct.new(responce_body)
    end

    def response_objects
      JSON.parse(response.body, object_class: OpenStruct)
    end

    def assert_body
      expect(response.body).to eq expected_response
    end

    def assert_response_object
      expect(response_object).to have_attributes(expected_response)
    end

    def assert_response_body
      expect(response_body).to eq(expected_response)
    end

    def self.generate_helpers
      %i(get post put patch delete).each do |http_verb|
        define_method :"do_#{http_verb}" do
          if Rails::VERSION::MAJOR >= 5
            public_send(http_verb, path, params: params, headers: headers)
          else
            public_send(http_verb, path, params, headers)
          end
        end

        RspecRequestHelpers.configuration.content_types.each do |type, mime_type|
          RspecRequestHelpers.configuration.symbols_with_status_codes.each do |status, code|
            %i(body response_object response_body).each do |resp_assertion|
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
