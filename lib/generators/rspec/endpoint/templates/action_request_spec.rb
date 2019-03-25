RSpec.describe '', type: :request do
  <% @path_params.each do |param| %>
  <%= "let(#{param}) { #{rand(99..500)} }" %>
  <% end %>
  path { "<%= @path %>" }
  headers  { {} }
  params   { {} }
  expected_response { {} }

  describe '<%= @http_verb.upcase %> <%= class_path.join('/') %>#<%= file_name %>' do
    context '' do
      xit 'renders correct response' do
        do_<%= @http_verb.downcase %>
      end
    end
  end
end
