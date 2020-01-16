#!/usr/bin/ruby
# @Author: Andrii Baran
# @Date:   2019-12-09 15:05:38
# @Last Modified by:   Andrii Baran
# @Last Modified time: 2020-01-16 12:17:32

module RspecRequestHelpers
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      template 'default_configuration.rb', 'config/initializers/rspec_request_helpers.rb'
    end
  end
end
