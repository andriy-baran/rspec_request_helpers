#!/usr/bin/ruby
# @Author: Andrii Baran
# @Date:   2019-12-18 11:29:56
# @Last Modified by:   Andrii Baran
# @Last Modified time: 2020-01-16 12:17:16

RSpec.describe '', type: :request do
  <% @path_params.each do |param| %>
  <%= "let(#{param}) { #{rand(99..500)} }" %>
  <% end %>
  path { "<%= @path %>" }
  headers  { {'Content-Type' => 'application/json', 'Accept' => 'application/json'} }
  params   { {} }
  response { {} }

  describe '<%= @http_verb.upcase %> <%= class_path.join('/') %>#<%= file_name %>' do
    context '' do
      xit 'renders correct response' do
        do_<%= @http_verb.downcase %>
      end
    end
  end
end
