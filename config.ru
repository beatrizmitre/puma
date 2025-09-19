INDEX = <<~HTML
<!doctype html>
<html>
  <head>
    <title>SSE Hang</title>
  </head>
  <body>
    <h1>SSE Hang</h1>
    <ul id="messages"></ul>
    <script>
      var source = new EventSource('/sse');
      source.onmessage = function(event) {
        console.log(event.data);
        var li = document.createElement('li');
        li.textContent = event.data;
        messages.appendChild(li);
      };
    </script>
  </body>
</html>
HTML

def index_response
  [200, {"content-type" => "text/html"}, [INDEX]]
end

def sse_response
  event_stream = proc do |stream|
    loop do
      stream.write "data: #{Time.now}\n\n"
      sleep 1
    end
  ensure
    stream.close
  end

  [200, {
    "content-type"  => "text/event-stream",
    "cache-control" => "no-cache",
  }, event_stream,]
end

run do |env|
  request = Rack::Request.new(env)

  case request.path
  when "/sse"
    sse_response
  else
    index_response
  end
end
