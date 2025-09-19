event_stream = proc do |stream|
  loop do
    stream.write "data: #{Time.now}\n\n"
    sleep 1
  end
ensure
  stream.close
end
