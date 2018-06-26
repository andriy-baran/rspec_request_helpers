module RspecRequestHelpers
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      template 'default_configuration.rb', 'config/initializers/rspec_request_helpers.rb'
    end
  end
end
