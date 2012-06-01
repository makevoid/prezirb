require 'em-websocket'
# require 'monkey/engine'
require 'capture_stdout'
require 'escape_utils'

class PrezIRB

  def initialize
    @prezirb_binding = binding
    @line = 1
    @output = nil
  end

  def eval_message(msg)
    stdout = capture_stdout do
      @output = eval(msg, @prezirb_binding, '(prezirb session)', @line)
    end
    stdout << @output.inspect
  end

  def process_message(ws, msg)
    response = ""
    begin
      response << eval_message(msg)
      @line += 1
    rescue Exception => e
      response << e.to_s << "\n" << e.backtrace.map { |l| "\t#{l}" }.join("\n")
    end
    ws.send escape_response(response)
  end

  def escape_response(response)
    EscapeUtils.escape_html(response).gsub("\n", "<br>").gsub("\t", "    ").gsub(" ", "&nbsp;")
  end

  def start_em_loop
    EventMachine.run do
      EventMachine::WebSocket.start(:host => '127.0.0.1', :port => 8080) do |ws|
        ws.onopen { ws.send 'console started' }
        ws.onmessage do |msg|
          process_message ws, msg
        end
      end
    end
  end

end

prezirb = PrezIRB.new
prezirb.start_em_loop