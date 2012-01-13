Titanium.UI.setBackgroundColor '#000'

win = Titanium.UI.createWindow
  title:'win1'
textarea = Titanium.UI.createTextArea
  value:''
win.add textarea
win.open()

socket
readBuffer = Titanium.createBuffer
  length:1024

readCallback = (e) ->
  if e.bytesProcessed == -1
    textarea.value += ">>Recieved socket closed \n"
    socket.close()
    return

  str = Ti.Codec.decodeString
    source:readBuffer
    length:e.bytesProcessed

  textarea.value = e.bytesProcessed + "> " + str + "\n" + textarea.value
  Ti.Stream.read socket,readBuffer,readCallback

socket = Ti.Network.Socket.createTCP
  host:'example.com'
  port:3535
  connected: (e) ->
    Ti.Stream.read socket,readBuffer,readCallback
    textarea.value += ">> Connected to host" + socket.host + "\n"

    data = Ti.createBuffer
      value:"GET /index.html HTTP/1.1\r\nHost:example.com\r\n\r\n"
    
    bytesWritten = socket.write data

  closed: (e) ->
    textarea.value += ">> Socket closed"

socket.connect()
