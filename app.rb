require 'json'
class App < Sinatra::Base

  set :views, settings.root + '/app/views'

  get '/' do
    haml :main
  end
  get '/test' do
    haml :test
  end

  error 401 do
    'Not Authorized'
  end
end

