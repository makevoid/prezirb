slides = [
  {
    title:  "-1) debug",
    code:   """
File.open('./tmp/index.html', 'w'){ |f| f.write page.body }
`open ./tmp/index.html`
    """
  },
  {
    title:  "0) start",
    code:   ""
  },
  {
    title:  "--- titolo",
    code:   "\"Tirare giu' il web con Net::HTTP e Mechanize\""
  },
  {
    title:  "--- ovvero",
    code:   "\"web scraping\""
  },
  {
    title:  "--- cos'e'",
    code:   """
cos'e' il web scraping?

- ottenere informazioni scaricando pagine web
"""
  },
  {
    title:  "--- perche'?",
    code:   """perche' il web scraping? 
- automazione task noiosi
- fare la media / ottenere la storia delle previsioni meteo da siti italiani
- controllare se ci sono nuovi post sui forum
- game bot (browsergame tipo ogame, travian, etc..)
- scaricare i resoconti (es tabelle html o file excel) dall'home banking
- mandarti un sms quando si aggiorna il sito della apple e stanno per uscire i nuovi iCosi

in sostanza:

scaricare tutti i dati dal web non disponibili via api
"""
  },
  {
    title:  "1) Net::HTTP",
    code:   """
require 'net/http'
"""
  },
  {
    title:  "--- get_response",
    code:   """
Net::HTTP.get_response URI.parse('http://example.com') # google.com
"""
  },
  {
     title:  "--- get_response google",
     code:   "Net::HTTP.get_response URI.parse('http://www.iana.org/domains/example')"
  },
  {
     title:  "--- get_response ngi body",
     code:   """
page = Net::HTTP.get_response URI.parse('http://ngi.it')
page.body"""
  },
  {
     title:  "--- nokogiri search title",
     code:   "
Nokogiri::HTML(page.body).search('title').text"
  },
  {
     title:  "--- get+nokogiri cantiere",
     code:   """
page = Net::HTTP.get_response URI.parse('http://cantierecreativo.net/it/home')
Nokogiri::HTML(page.body).search('title').text"""
  },
  {
    title:  "2) Mechanize",
    code:   """Mechanize gem
    
- has a friendly api 
- offers cookies persistance
- follows redirects automatically
"""
  },
  {
     title:  "--- basic api",
     code:   """
require 'mechanize'
agent = Mechanize.new
"""
  },
  {
     title:  "--- user agent",
     code:   """
agent.user_agent = 'Mac Safari'
"""
  },
  {
     title:  "--- get",
     code:   """
page = agent.get "http://google.com"
"""
  },
  {
     title:  "--- explanations",
     code:   """
page responds to 

page.body
page.search # page is a nokogiri object wrapped

form = page.forms.first
form.field_name = "value"
form.submit

# mantains authentication
"""
  },
  {
     title:  "--- rdoc",
     code:   """
http://mechanize.rubyforge.org

examples: http://mechanize.rubyforge.org/EXAMPLES_rdoc.html
"""
  },
  {
    title:  "3) Thread",
    code:   """
t = Thread.new do
  puts "started"
  sleep 3
  puts "finished"
end
t.join
"""
  },
  {
    title:  "--- intro",
    code:   """
t1 = Thread.new do
  puts "[1] started"
  sleep 2
  puts "[1] finished"
end


t2 = Thread.new do
  puts "[2] started"
  sleep 2
  puts "[2] finished"
end


t1.join
t2.join
"""
  },
  {
    title:  "--- example",
    code:   """
threads = []

urls = ["http://cantierecreativo.net/it/home", "http://cantierecreativo.net/it/chi-siamo", "http://cantierecreativo.net/it/blog"]

pages.each do |page|
  thread = Thread.new do 
    Net::HTTP.get_response URI.parse(url)
  end
end
"""
  },
  {
    title:  "4) Keep-Alive",
    code:   """use http header Keep-Alive trough Net::HTTP
to persist http connections

- increases scraping time a lot when scraping the same domain
"""
  },
  {
    title:  "--- KeepAlive example",
    code:   """
page1 = ""
page2 = ""

uri = URI.parse 'http://bitclan.it'
Net::HTTP.start(uri.host, uri.port) do |http|
  page1 = http.get "/"
  page2 = http.get "/forums/1"  
end
    """
  },
  
  
  {
    title:  "--- Wrapping and benchmark",
    code:   """
https://gist.github.com/1298812
"""
  },
  
  {
    title:  "--- demo",
    code:   """
  
  require 'net/http'

  class Getter # simplifies the Net::HTTP api a bit

    attr_reader :uri

    def initialize(host, protocol=nil)
      prot = protocol || "http"
      url = "\#{prot}://\#{host}"
      @uri = URI.parse url
    end

    def start(&block)
      Net::HTTP.start(@uri.host, @uri.port) do |http|
        @http = http
        block.call(self)
      end
    end

    def get(path)
      resp = @http.get path
      resp.body
    end

  end


  NUM = 4

  require 'benchmark'

  bench1 = Benchmark.measure do
    g = Getter.new "makevoid.com"
    g.start do |g|
      NUM.times do
        g.get "/"
      end
    end
  end

  bench2 = Benchmark.measure do
    NUM.times do
      uri = URI.parse "http://makevoid.com"
      Net::HTTP.get_response uri
    end
  end

  puts "\#{NUM} requests"
  puts "With Keep-Alive HEADER (all gets within a start block)"
  puts bench1

  puts "without (normal get_response)"
  puts bench2"""
  },

  {
    title:  "6) About this presentation",
    code:   """
prezirb
  
search prezirb on github!
    """
  },
  {
    title:  "--- prezirb",
    code:   """
- forked from rkh/brirb
- revamped ui
- sidebar for presentation

search prezirb on github!
"""
  },
  {
    title:  "--- the end ",
    code:   "100.times{ puts 'the end! ' }; true"
  },
  {
    title:  "",
    code:   ""
  },
  {
    title:  "",
    code:   ""
  },
  {
    title:  "<br><br><br><br><br><br><br><br><br><br><br>",
    code:   ""
  }
]

window.slides = slides