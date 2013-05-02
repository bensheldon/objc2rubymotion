require 'json'
class App < Sinatra::Base

  set :views, settings.root + '/app/views'

  get '/' do
    @placeholder = <<-eos
UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Warning"
                                                 message:@"too many alerts"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil] autorelease];
[alert show];
    eos



    haml :main
  end
  get '/test' do
    haml :test
  end

  error 401 do
    'Not Authorized'
  end
end

