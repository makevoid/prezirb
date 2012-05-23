snippets = [
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
    
search prezirb on github
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

window.snippets = snippets

configs = {}
configs.max_length = 400


views = {}

history = []
history_redo = []

views.cmd = (args) -> 
  arrow = "&nbsp;" 
  # arrow = "=>"
  cmd = args.cmd.replace(/\n/g, "<br>")
  "<div class='cmd'>#{cmd}</div>"

views.out = (args) ->
  arrow = "&nbsp;"
  # arrow = "&gt;&gt;"
  if args.out.length > configs.max_length
    truncated = args.out.substring(0, configs.max_length)
    # <a class='browser_btn' href='javascript:void(0)'>o</a>
    "
    <div class='out'>
       <div class='truncated'>#{truncated}<a href='javascript:void(0)'>...</a></div>
       <div class='full'>#{args.out}<a href='javascript:void(0)'>&rgt;</a></div>
     </div>"
  else
    "<div class='out'>#{args.out}</div>"


scroll = ->
  $(".log_scroll").scrollTop($("#log").height())

output = (str) ->
  input = $("#input")
  $("#log").append str
  input.attr {scrollTop: input.attr("scrollHeight") }
  scroll()
  expand_commands()
  bind_open_browser(str)
  
bind_open_browser = (str) ->
  $(".browser_btn").on "click", =>
    string = $(str).find(".full").text()
    window.browser.open string


execute = (cmd) ->
  history.push cmd
  window.ws.send cmd

ws = new WebSocket("ws://127.0.0.1:8080")
window.ws = ws
window.execute = execute
window.history = history

ws.onmessage = (e) -> 
  output views.out(out: e.data)
ws.onclose   = -> output "prezirb is closed: start it with 'ruby prezirb.rb'"
ws.onerror   = -> output "!!! ERROR !!!"


watch_keyboard = ->
  $("#input").on "keydown", (evt) ->
    watch_run evt
    watch_history evt

    
watch_run = (evt) ->
  enter = 13
  if evt.metaKey && evt.keyCode == enter
    $("form.input").submit()
  
watch_history = (evt) ->
  arrow_up = 38
  arrow_down = 40
  if evt.metaKey && (evt.keyCode == arrow_up || evt.keyCode == arrow_down)
    evt.preventDefault()
    if evt.keyCode == arrow_up
      unless history == []
        cmd = history.pop() 
        history_redo.push cmd
        $("#input").val cmd
    if evt.keyCode == arrow_down
      unless history_redo == []
        cmd = history_redo.pop()
        history.push cmd
        $("#input").val cmd
  

watch_commands = ->
  $("form").submit (evt) ->
    evt.preventDefault()
    input = $("#input")
    input.focus()
    value = input.val()

    execute value

    output views.cmd(cmd: value), input
    input.val ""
    input.focus()
    false


expand_commands = ->
  $(".truncated a").off "click"
  $(".truncated a").on "click", ->
    truncated = $(this).parent()
    truncated.hide()
    truncated.parent().children(".full").show()
    scroll()


watch_sidebar = ->
  $(".snippets a").on "click", (evt) ->
    idx = $(evt.target).data "snippet-id"
    snippet = window.snippets[idx]
    input = $("#input")
    input.val $.trim(snippet.code)
    fix_textarea_height()
    input.focus()
    
watch_textarea_height = ->
  $("#input").on "keydown", ->
    fix_textarea_height()

fix_textarea_height = ->
  input = $("#input")
  if input.val().match("\n")
    input.addClass("tall")
  else
    input.removeClass("tall")

load_snippets = ->
  snippets = _(snippets).map (snippet, idx) ->
    load_snippet snippet, idx
  $(".snippets").html snippets.join("")
  watch_sidebar()
    

load_snippet = (snip, idx) ->
  "<p><a data-snippet-id='#{idx}' href='javascript:void(0)'>#{snip.title}</a></p>"


browser = {}
window.browser = browser

browser.open = (string) ->
  # Net::HTTP.get_response(URI.parse('http://makevoid.com')).body
  console.log string
  string = $($(string)[1]).html()
  string = unescape(string)
  console.log string
  $(".browser .iframe").html string
  $(".browser").show()
  @watch()
  
browser.watch = ->
  $(".browser .close").off "click"
  $(".browser .close").on "click", =>
    $(".browser").hide()

$ ->
  watch_keyboard()
  watch_commands()
  watch_textarea_height()
  load_snippets()
  browser.watch()