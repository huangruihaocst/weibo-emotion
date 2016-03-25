require 'json'

app = lambda do |env|

  url = '/' + env['REQUEST_URI'].split('/')[3..-1].join('/')
  if url == '/'
    page = open('public/view.html').read.to_s
    return ['200', {'Content-Type' => 'text/html'}, [page]]
  elsif url.include? '/redirect'
    page = open('public/redirect.html').read.to_s
    return ['200', {'Content-Type' => 'text/html'}, [page]]
  end

end

run app