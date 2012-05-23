snippets = {
  start: "",
  start: "",
  net_http: "require 'net/http'\n
a = b\n
b = c
  ",
  mechanize: "",
  thread: "",
}

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
ws.onclose   = -> output "brirb is closed: start it with 'ruby brirb.rb'"
ws.onerror   = -> output "!!! ERROR !!!"


watch_history = ->
  $("#input").on "keydown", (evt) ->
    arrow_up = 38
    arrow_down = 40
    if evt.keyCode == arrow_up || evt.keyCode == arrow_down
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
  $(".aside a").on "click", (evt) ->
    name = $(evt.target).data "name"
    snippet = snippets[name]
    input = $("#input")
    input.val snippet
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


$ ->
  watch_history()
  watch_commands()
  watch_sidebar()
  watch_textarea_height()