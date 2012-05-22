# encoding: utf-8
require 'sinatra'
require 'instagram'
require 'haml'
require 'choices'
require 'digest/md5'

Choices.load_settings(File.join(settings.root, 'config.yml'), settings.environment.to_s).each do |key, value|
  set key.to_sym, value
end

Instagram.configure do |config|
  for key, value in settings.instagram
    config.send("#{key}=", value)
  end
end

configure :development do
  set :logging, false
end

helpers do

  def absolute_url(path)
    abs_uri = "#{request.scheme}://#{request.host}"

    if request.scheme == 'https' && request.port != 443 ||
          request.scheme == 'http' && request.port != 80
      abs_uri << ":#{request.port}"
    end

    abs_uri << path
  end
  
  def root_path?
    request.path == '/'
  end
  
  def log_error(boom = $!, env = nil)
    super(boom, env) do |to_store|
      if to_store.exception.is_a? Instagram::Error
        params = (to_store['session'] ||= {})
        params.update('response_body' => to_store.exception.response.body)
      end
      yield to_store if block_given?
    end
  end

  def check_data(response)
    if 200 == response.status
      String === response ? response : response.data
    else
      response.error!
    end
  end

end

set :dump_errors, false
# set :show_exceptions, false

error do
  err = env['sinatra.error']
  log_error err
  status 500

  if err.respond_to?(:response) and (body = err.response && err.response.body).is_a? Hash
    msg = if body['meta']
      "%s: %s" % [ body['meta']['error_type'], body['meta']['error_message'] ]
    else
      body['error_message'] || "Something is not right."
    end
    haml "%h1 Error.\n%p #{msg}"
  else
    haml "%h1 Error: can't perform this operation\n%p Please, try again later."
  end
end

get '/' do
  "Oauth Data Proxy"
  expires settings.expires.index_page, :public
end

get '/login' do
  haml "%a{:href => '/instagram/login'} Instagram"
end

get '/:source/login' do 
  case params[:source].downcase.to_sym
  when :instagram
    return_url = request.url.split('?').first
    begin
      if params[:code]
        token_response = Instagram::get_access_token(return_to: return_url, code: params[:code])
        puts token_response.body
        haml token_response.body
        # user = User.from_token token_response.body
        # redirect user_url(user.username)
        
        
        # env['INSTAGRAM_TOKEN'] = token_response.body.access_token
        # Instagram.configure do |config|
        #   instagram_token = env['INSTAGRAM_TOKEN']
        # end
      elsif params[:error]
        status 401
        haml "%h1 Can't login: #{params[:error_description]}"
      else
        redirect Instagram::authorization_url(return_to: return_url).to_s
      end
    end
  end
end

get '/help' do
  # @title = "Help page"
  expires settings.expires.help_page, :public
  haml :help
  settings.instagram.class
end

get '/:source/*' do
  case params[:source].downcase.to_sym
  when :instagram
    # "instagram! "
    # Instagram.get(params[:splat].join("/"), :raw => true)
    # haml "Get this from instagram: #{params[:splat]}"
    
    # puts Instagram.get_url(params[:splat].join("/")).methods
    # puts Instagram.get_url(params[:splat].join("/"))
    
    callback = params['_callback']
    raw_json = check_data Instagram.get(params[:splat].join("/"), :raw => true)
    content_type "application/#{callback ? 'javascript' : 'json'}", charset: 'utf-8'
    expires settings.expires.data_cache, :public
    etag Digest::MD5.hexdigest(raw_json)
    if callback
      "#{callback}(#{raw_json.strip})"
    else
      raw_json
    end
    
  when :twitter
    "twitter "
  end
end

