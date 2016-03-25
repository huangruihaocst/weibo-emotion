require 'json'
require 'open-uri'
require 'net/http'

client_id = '144361011'
client_secret = 'af5851b75f0346ffca0a0f0563d31239'
redirect_page = 'http://127.0.0.1:9292/redirect'

app = lambda do |env|

  url = '/' + env['REQUEST_URI'].split('/')[3..-1].join('/')
  if url == '/'
    page = open('public/view.html').read.to_s
    return ['200', {'Content-Type' => 'text/html'}, [page]]
  elsif url.include? '/redirect'
    code = url.split('=')[1]
    page = open('public/redirect.html').read.to_s
    raw_uri = 'https://api.weibo.com/oauth2/access_token?client_id='+ client_id +
        '&client_secret=' + client_secret + '&grant_type=authorization_code&redirect_uri=' +
        redirect_page + '&code=' + code
    uri = URI(raw_uri)
    res = Net::HTTP.post_form(uri, {})#json
    access_token = (JSON.parse res.body)['access_token']
    return ['200', {'Content-Type' => 'text/html'}, [access_token]]
  end

end

run app