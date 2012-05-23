snippets = [
  {
    title:  "notes:",
    code:   "get_response google"
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
    title:  "1) Net::HTTP",
    code:   """
require 'net/http'
"""
  },
  {
    title:  "--- get_response",
    code:   """
Net::HTTP.get_response URI.parse('http://')
"""
  },
  {
     title:  "--- get_response google",
     code:   "Net::HTTP.get_response URI.parse('http://google.com')"
  },
  {
     title:  "--- get_response ngi body",
     code:   "
page = Net::HTTP.get_response URI.parse('http://ngi.it')
page.body"
  },
  {
     title:  "--- nokogiri search title",
     code:   "
Nokogiri::HTML(page.body).search('title').text"
  },
  {
     title:  "--- get_response ngi body",
     code:   "
page = Net::HTTP.get_response URI.parse('http://cantierecreativo.net/it/home')
page.body"
  },
  {
    title:  "2) Mechanize",
    code:   ""
  },
  {
    title:  "3) Thread",
    code:   ""
  },
  {
    title:  "4) Keep-Alive",
    code:   ""
  },
  {
    title:  "5) Wrapping and benchmarks",
    code:   ""
  },
  {
    title:  "--- ",
    code:   ""
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
    title:  "",
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
  "<div class='cmd'>#{args.cmd}</div>"

views.out = (args) ->
  arrow = "&nbsp;"
  # arrow = "&gt;&gt;"
  if args.out.length > configs.max_length
    truncated = args.out.substring(0, configs.max_length)
    "
    <div class='out'>
       <div class='truncated'>#{truncated}<a href='javascript:void(0)'>...</a></div>
       <div class='full'>#{args.out}</div>
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



$ ->
  watch_keyboard()
  watch_commands()
  watch_textarea_height()
  load_snippets()