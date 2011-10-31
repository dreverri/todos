# -*- coding: utf-8 -*-
require 'sinatra/base'
require 'ripple'
require 'riak-sessions'
require 'omniauth'
require 'active_support/dependencies'

# Models
require 'models/authorization'
require 'models/credentials'
require 'models/user_info'
require 'models/user'

def riak_is_not_running
  puts <<eos

    Riak is not listening at the configured location:

        #{Ripple.client.http.path(Ripple.client.prefix)}

    Please make sure Riak is running and the "config/ripple.yml" file
    is setup correctly.

eos
  exit 1
end

def missing_settings_file
  puts <<eos

    The file "config/settings.yml" is missing. You will need to create
    this file and populate it with valid Twitter API keys. An example
    is provided in "config/settings.yml.example". Checkout the Twitter
    developer documentation to get your API keys:

        https://dev.twitter.com/docs

eos
  exit 1
end

class App < Sinatra::Base
  configure do
    enable :logging
    config_dir = File.join(File.dirname(__FILE__), '..', 'config')
    Ripple.load_config(config_dir + '/ripple.yml', [settings.environment])

    begin
      c = YAML.load(ERB.new(File.read(config_dir + '/settings.yml')).result)
      c.each { |k,v| set k.to_sym, v }
    rescue
      missing_settings_file
    end

    begin
      User.bucket.allow_mult=true
    rescue
      riak_is_not_running
    end
  end

  # Session storage
  use Riak::SessionStore, Ripple.config

  # 3rd party authorization
  use OmniAuth::Builder do
    provider :twitter, App.settings.twitter['key'], App.settings.twitter['secret']
  end

  # Server
  helpers do
    def current_user
      @current_user ||= User.find(session['user_key']) if session['user_key']
    end
  end

  not_found do
    "Nothing to see here"
  end

  error do
    "Something broke"
  end

  get '/' do
    if current_user
      File.read(File.join(settings.views, 'index.html'))
    else
      erb :login
    end
  end

  before '/todos*' do
    redirect '/' unless current_user
    content_type :json
    current_user.todos ||= []
  end

  get '/todos' do
    current_user.todos.to_json
  end

  post '/todos' do
    todo = JSON.parse(request.env['rack.input'].read).merge(:id => SecureRandom.hex(10))
    current_user.todos << todo
    current_user.save!
    todo.to_json
  end

  put '/todos/:id' do
    current_user.todos.delete_if { |t| t["id"] == params[:id] }
    todo = JSON.parse(request.env['rack.input'].read)
    current_user.todos << todo
    current_user.save!
    todo.to_json
  end

  delete '/todos/:id' do
    current_user.todos.delete_if { |t| t["id"] == params[:id] }
    current_user.save!
  end
  
  # User authorization
  get '/logout' do
    session['user_key'] = nil
    redirect to('/')
  end

  get '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    unless @auth = Authorization.find_from_auth(auth)
      @auth = Authorization.create_from_auth!(auth, current_user)
    end

    session['user_key'] = @auth.user.key
    redirect to('/')
  end

  get '/auth/failure' do
    "Authorization failure"
  end
end
