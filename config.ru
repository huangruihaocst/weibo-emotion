require 'json'
require 'open-uri'
require 'net/http'
require 'rack'
require 'rubygems'

client_id = '144361011'
client_secret = 'af5851b75f0346ffca0a0f0563d31239'
redirect_page = 'http://127.0.0.1:9292/redirect'

use Rack::Static,
    :urls => %w(/js /Flat-UI-master),
    :root => 'public'

def emotion(emoticons)
  emotions = {"\u{1F600}"=>1, "\u{1F601}"=>1, "\u{1F602}"=>1, "\u{1F603}"=>1, "\u{1F604}"=>1, "\u{1F605}"=>0.5,
          "\u{1F606}"=>1, "\u{1F607}"=>1, "\u{1F608}"=>0.5, "\u{1F609}"=>1, "\u{1F60A}"=>1, "\u{1F60B}"=>1,
          "\u{1F60C}"=>1, "\u{1F60D}"=>1, "\u{1F60E}"=>1, "\u{1F60F}"=>0.5, "\u{1F610}"=>0, "\u{1F611}"=>0,
          "\u{1F612}"=>0, "\u{1F613}"=>-0.5, "\u{1F614}"=>-0.5, "\u{1F615}"=>-0.5, "\u{1F616}"=>-1, "\u{1F617}"=>0,
          "\u{1F618}"=>1, "\u{1F619}"=>1, "\u{1F61A}"=>1, "\u{1F61B}"=>0, "\u{1F61C}"=>0.5, "\u{1F61D}"=>-0.5,
          "\u{1F61F}"=>-1, "\u{1F620}"=>-1, "\u{1F621}"=>-1, "\u{1F622}"=>-1, "\u{1F623}"=>-1, "\u{1F624}"=>-1,
          "\u{1F625}"=>-1, "\u{1F626}"=>-1, "\u{1F627}"=>-1, "\u{1F628}"=>-1, "\u{1F629}"=>-1, "\u{1F62A}"=>-1,
          "\u{1F62B}"=>-1, "\u{1F62C}"=>-1, "\u{1F62D}"=>-1, "\u{1F62E}"=>0, "\u{1F62F}"=>-0.5, "\u{1F630}"=>-1,
          "\u{1F631}"=>-1, "\u{1F632}"=>-1, "\u{1F633}"=>0, "\u{1F634}"=>0, "\u{1F635}"=>-1, "\u{1F636}"=>0,
          "\u{1F637}"=>-1, "\u{1F638}"=>1, "\u{1F639}"=>1, "\u{1F63A}"=>1, "\u{1F63B}"=>1, "\u{1F63C}"=>0.5,
          "\u{1F63D}"=>0.5, "\u{1F63E}"=>-0.5, "\u{1F63F}"=>-1, "\u{1F640}"=>-1, "\u{1F641}"=>-1, "\u{1F642}"=>1,
          "\u{1F643}"=>0, "\u{1F644}"=>0, "\u{1F645}"=>-0.5, "\u{1F646}"=>0.5, "\u{1F647}"=>-0.5, "\u{1F648}"=>0.5,
          "\u{1F649}"=>0.5, "\u{1F64A}"=>-0.5, "\u{1F64B}"=>0, "\u{1F64C}"=>1, "\u{1F64D}"=>-1, "\u{1F64E}"=>-0.5,
          "\u{1F64F}"=>-0.5}
  count = 0
  emoticons.each do |e|
    count += emotions[e]
  end
  count
end

app = lambda do |env|

  url = '/' + env['REQUEST_URI'].split('/')[3..-1].join('/')
  if url == '/'
    return ['200',
            {'Content-Type' => 'text/html',
                'Cache-Control' => 'public, max-age=86400'},
    File.open('public/view.html', 'r')]
  elsif url.include? '/redirect'
    #get access token
    code = url.split('=')[1]
    raw_uri = 'https://api.weibo.com/oauth2/access_token?client_id='+ client_id +
        '&client_secret=' + client_secret + '&grant_type=authorization_code&redirect_uri=' +
        redirect_page + '&code=' + code
    uri = URI(raw_uri)
    res = Net::HTTP.post_form(uri, {})
    access_token = (JSON.parse res.body)['access_token']
    #get user timeline
    raw_uri = 'https://api.weibo.com/2/statuses/user_timeline.json?access_token=' + access_token
    uri = URI(raw_uri)
    res = Net::HTTP.get(uri)
    contents = []
    res_hash = JSON.parse res
    res_hash['statuses'].each do |status|
      contents << status['text']
    end
    emoticons = []
    contents.each do |content|
      content.scan(/[\u{1F600}-\u{1F64F}]/) do |emoticon|
        emoticons << emoticon
      end
    end
    emotion_val = emotion(emoticons)
    #load html
    page = open('public/redirect.html').read.to_s
    page['<p>这是回调页面</p>'] = '你的分数： ' + emotion_val.to_s
    return ['200', {'Content-Type' => 'text/html'}, [page]]
  end

end

run app
