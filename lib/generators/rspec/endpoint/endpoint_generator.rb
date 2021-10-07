#!/usr/bin/ruby
# @Author: Andrii Baran
# @Date:   2019-12-18 13:04:57
# @Last Modified by:   Andrii Baran
# @Last Modified time: 2020-01-16 12:17:23

module Rspec
  class EndpointGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      routes = Rails.application.routes.routes
      route_regexp = Regexp.new("#{class_path.join('/')}##{file_name}")
      rails_route = routes.detect { |r| ActionDispatch::Routing::RouteWrapper.new(r).endpoint.match(route_regexp) }
      rails_route || raise("#{class_path.join('/')}##{file_name} not found in routes")
      @route = rails_route.path.spec.to_s
      @http_verb = rails_route.verb
      @path = @route[/(\/.*)\(/, 1]
      @path_params = @path.split('/').select{|i| i[/:/]}
      @path_params.each do |param|
        @path.sub!(param, '#{' + param[1..-1] + '}')
      end
      if behavior == :revoke
        template 'action_request_spec.rb', "spec/requests/#{file_path}_spec.rb"
      elsif behavior == :invoke
        empty_directory Pathname.new('spec/requests').join(*class_path)
        template 'action_request_spec.rb', "spec/requests/#{file_path}_spec.rb"
      end
    end
  end
end
