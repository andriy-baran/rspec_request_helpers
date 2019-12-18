module Rspec
  class EndpointGenerator < Rails::Generators::NamedBase
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
      @route = routes.split("\n").grep(Regexp.new "#{class_path.join('/')}##{file_name}").first || raise("#{class_path.join('/')}##{file_name} not found in routes")
      @http_verb = @route[/GET|POST|DELETE|PUT|PATCH/]
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
