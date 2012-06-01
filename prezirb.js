(function() {
  var bind_open_browser, browser, configs, execute, expand_commands, fix_textarea_height, history, history_redo, load_snippet, load_snippets, output, scroll, slides, views, watch_commands, watch_history, watch_keyboard, watch_run, watch_sidebar, watch_textarea_height, ws;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  slides = [
    {
      title: "Hello",
      code: "'Welcome into PrezIRB'"
    }, {
      title: "PreziIRB",
      code: "PreziIRB = 'presentation'"
    }, {
      title: "What is PreziIRB?",
      code: "PreziIRB == 'presentation'"
    }, {
      title: "You need to show the code",
      code: "code = [83, 104, 111, 119, 32, 109, 101, 32, 116, 104, 101, 32, 99, 111, 100, 101, 33]\ncode.pack \"c*\""
    }, {
      title: "better for q/a, very interactive experience, customize it more than irb, embed in a showoff presentation",
      code: ""
    }, {
      title: "net http",
      code: "require 'net/http'\npage = Net::HTTP.get_response URI.parse(\"http://www.ruby-lang.org/en/\")"
    }, {
      title: "open tab example",
      code: "File.open('./tmp/index.html', 'w'){ |f| f.write page.body }\n`open ./tmp/index.html`"
    }
  ];
  window.slides = slides;
  configs = {};
  configs.max_length = 400;
  views = {};
  history = [];
  history_redo = [];
  views.cmd = function(args) {
    var arrow, cmd;
    arrow = "&nbsp;";
    cmd = args.cmd.replace(/\n/g, "<br>");
    return "<div class='cmd'>" + cmd + "</div>";
  };
  views.out = function(args) {
    var arrow, truncated;
    arrow = "&nbsp;";
    if (args.out.length > configs.max_length) {
      truncated = args.out.substring(0, configs.max_length);
      return "    <div class='out'>       <div class='truncated'>" + truncated + "<a href='javascript:void(0)'>...</a></div>       <div class='full'>" + args.out + "<a href='javascript:void(0)'>&rgt;</a></div>     </div>";
    } else {
      return "<div class='out'>" + args.out + "</div>";
    }
  };
  scroll = function() {
    return $(".log_scroll").scrollTop($("#log").height());
  };
  output = function(str) {
    var input;
    input = $("#input");
    $("#log").append(str);
    input.attr({
      scrollTop: input.attr("scrollHeight")
    });
    scroll();
    expand_commands();
    return bind_open_browser(str);
  };
  bind_open_browser = function(str) {
    return $(".browser_btn").on("click", __bind(function() {
      var string;
      string = $(str).find(".full").text();
      return window.browser.open(string);
    }, this));
  };
  execute = function(cmd) {
    history.push(cmd);
    return window.ws.send(cmd);
  };
  ws = new WebSocket("ws://127.0.0.1:8080");
  window.ws = ws;
  window.execute = execute;
  window.history = history;
  ws.onmessage = function(e) {
    return output(views.out({
      out: e.data
    }));
  };
  ws.onclose = function() {
    return output("prezirb is closed: start it with 'ruby prezirb.rb'");
  };
  ws.onerror = function() {
    return output("!!! ERROR !!!");
  };
  watch_keyboard = function() {
    return $("#input").on("keydown", function(evt) {
      watch_run(evt);
      return watch_history(evt);
    });
  };
  watch_run = function(evt) {
    var enter;
    enter = 13;
    if (evt.metaKey && evt.keyCode === enter) {
      return $("form.input").submit();
    }
  };
  watch_history = function(evt) {
    var arrow_down, arrow_up, cmd;
    arrow_up = 38;
    arrow_down = 40;
    if (evt.metaKey && (evt.keyCode === arrow_up || evt.keyCode === arrow_down)) {
      evt.preventDefault();
      if (evt.keyCode === arrow_up) {
        if (history !== []) {
          cmd = history.pop();
          history_redo.push(cmd);
          $("#input").val(cmd);
        }
      }
      if (evt.keyCode === arrow_down) {
        if (history_redo !== []) {
          cmd = history_redo.pop();
          history.push(cmd);
          return $("#input").val(cmd);
        }
      }
    }
  };
  watch_commands = function() {
    return $("form").submit(function(evt) {
      var input, value;
      evt.preventDefault();
      input = $("#input");
      input.focus();
      value = input.val();
      execute(value);
      output(views.cmd({
        cmd: value
      }), input);
      input.val("");
      input.focus();
      return false;
    });
  };
  expand_commands = function() {
    $(".truncated a").off("click");
    return $(".truncated a").on("click", function() {
      var truncated;
      truncated = $(this).parent();
      truncated.hide();
      truncated.parent().children(".full").show();
      return scroll();
    });
  };
  watch_sidebar = function() {
    return $(".snippets a").on("click", function(evt) {
      var idx, input, snippet;
      idx = $(evt.target).data("snippet-id");
      snippet = window.slides[idx];
      input = $("#input");
      input.val($.trim(snippet.code));
      fix_textarea_height();
      return input.focus();
    });
  };
  watch_textarea_height = function() {
    return $("#input").on("keydown", function() {
      return fix_textarea_height();
    });
  };
  fix_textarea_height = function() {
    var input;
    input = $("#input");
    if (input.val().match("\n")) {
      return input.addClass("tall");
    } else {
      return input.removeClass("tall");
    }
  };
  load_snippets = function() {
    var snippets;
    snippets = _(slides).map(function(snippet, idx) {
      return load_snippet(snippet, idx);
    });
    $(".snippets").html(snippets.join(""));
    return watch_sidebar();
  };
  load_snippet = function(snip, idx) {
    return "<p><a data-snippet-id='" + idx + "' href='javascript:void(0)'>" + snip.title + "</a></p>";
  };
  browser = {};
  window.browser = browser;
  browser.open = function(string) {
    console.log(string);
    string = $($(string)[1]).html();
    string = unescape(string);
    console.log(string);
    $(".browser .iframe").html(string);
    $(".browser").show();
    return this.watch();
  };
  browser.watch = function() {
    $(".browser .close").off("click");
    return $(".browser .close").on("click", __bind(function() {
      return $(".browser").hide();
    }, this));
  };
  $(function() {
    watch_keyboard();
    watch_commands();
    watch_textarea_height();
    load_snippets();
    return browser.watch();
  });
}).call(this);
