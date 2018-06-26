module Rspec
  class EndpointGenerator < Rails::Generators::NamedBase
    desc 'Generate a spec/requests file for specified action of controller'

    argument :controller, type: :string, required: true, banner: 'CONTOLLER'

    source_root File.expand_path('../templates', __FILE__)

    # https://www.rubytapas.com/2012/11/28/episode-029-redirecting-output/
    def capture_output
      fake_stdout = StringIO.new
      old_stdout = $stdout
      $stdout = fake_stdout
      yield
    ensure
      $stdout = old_stdout
      return fake_stdout.string
    end

    def copy_files
      Rails.application.load_tasks
      routes = capture_output { Rake::Task['routes'].invoke }
      @route = routes.split("\n").grep(Regexp.new "#{controller}##{file_name}").first || raise("#{controller}##{file_name} not found in routes")
      @http_verb = @route[/GET|POST|DELETE|PUT|PATCH/]
      @path = @route[/(\/.*)\(/, 1]
      @path_params = @path.split('/').select{|i| i[/:/]}
      @path_params.each do |param|
        @path.sub!(param, '#{' + param[1..-1] + '}')
      end
      empty_directory "spec/requests/#{controller}"
      template 'action_request_spec.rb', "spec/requests/#{controller}/#{file_name}_spec.rb"
    end
  end
end
