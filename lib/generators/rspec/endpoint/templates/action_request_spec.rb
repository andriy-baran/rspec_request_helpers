RSpec.describe '', type: :request do
  <% @path_params.each do |param| %>
  <%= "let(#{param}) { #{rand(99..500)} }" %>
  <% end %>
  let(:path) { "<%= @path %>" }
  let(:valid_headers)  { {} }
  let(:valid_params)   { {} }
  let(:valid_response) { {} }

  describe '<%= @http_verb.upcase %> <%= controller %>#<%= file_name %>' do
    context '' do
      xit 'renders correct response' do
        do_<%= @http_verb.downcase %>
      end
    end
  end
end
