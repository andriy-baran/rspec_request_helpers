module RspecRequestHelpers
  module Helpers
    module ClassMethods
      require 'parser/current'

      class DatabaseDSLTranslator < ::Parser::TreeRewriter
        def on_send(node)
          _, method_name, *args = node.children

          factory_attrs = args.map { |e| e.loc.expression.source }.join(', ')

          case method_name
          when /list!$/
            replace(node.loc.expression, "let!(:#{method_name.to_s.sub(/list!$/,'')}) { FactoryBot.create_list(#{factory_attrs}) }")
          when /list$/
            replace(node.loc.expression, "let(:#{method_name.to_s.sub(/list$/,'')}) { FactoryBot.create_list(#{factory_attrs}) }")
          when /!$/
            replace(node.loc.expression, "let!(:#{method_name.to_s.sub(/!$/,'')}) { FactoryBot.create(#{factory_attrs}) }")
          else
            replace(node.loc.expression, "let(:#{method_name}) { FactoryBot.create(#{factory_attrs}) }")
          end
        end
      end

      #
      # Tiny DSL for creating list or single database records
      # via factory_bot syntax and Rspec :let or :let! methods
      # Usage:
      # user(:user, name: 'Bob') is translated to let(:user) { FactoryBot.create(:user, name: 'Bob') }
      # user!(:user, name: 'Bob') is translated to let!(:user) { FactoryBot.create(:user, name: 'Bob') }
      # user_list(:user, name: 'Bob', 3) is translated to let(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
      # user_list!(:user, name: 'Bob', 3) is translated to let!(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
      #
      def database(&block)
        parser        = Parser::CurrentRuby.new
        rewriter      = DatabaseDSLTranslator.new
        buffer        = Parser::Source::Buffer.new('(string)')
        buffer.source = Parser::CurrentRuby.parse(block.source).children.last.loc.expression.source
        rspec_factory = rewriter.rewrite(buffer, parser.parse(buffer))
        self.class_eval(rspec_factory)
      end

      class VarsDSL
        def initialize(klass)
          @klass = klass
        end

        def method_missing(method_name, *args, &block)
          case method_name
          when /!$/
            @klass.class_eval { let!(:"#{method_name.to_s.sub(/!$/,'')}", &block) }
          else
            @klass.class_eval { let(method_name, &block) }
          end
        end
      end

      def vars(&block)
        VarsDSL.new(self).instance_eval(&block)
      end

      def path(&block)
        let(:path, &block)
      end

      def valid_params(&block)
        let(:valid_params, &block)
      end

      def valid_headers(&block)
        let(:valid_headers, &block)
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
            public_send(http_verb, path, params: valid_params, headers: valid_headers)
          else
            public_send(http_verb, path, valid_params, valid_headers)
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
