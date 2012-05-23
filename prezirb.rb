require 'em-websocket'
# require 'monkey/engine'
require 'capture_stdout'
require 'escape_utils'

EventMachine.run do
  EventMachine::WebSocket.start(:host => '127.0.0.1', :port => 8080) do |ws|
    prezirb_binding = binding
    line = 1
    _ = nil
    ws.onopen { ws.send 'console started' }
    ws.onmessage do |msg|
      response = ""
      begin
        stdout = capture_stdout do
          _ = eval(msg, prezirb_binding, '(prezirb session)', line)
        end
        line += 1
        response << stdout << _.inspect
      rescue Exception => e
        response << e.to_s << "\n" << e.backtrace.map { |l| "\t#{l}" }.join("\n")
      end
      ws.send EscapeUtils.escape_html(response).gsub("\n", "<br>").gsub("\t", "    ").gsub(" ", "&nbsp;")
    end
  end
end
