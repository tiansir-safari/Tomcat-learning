
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>HaluoChat</title>
  <link rel="stylesheet" href="layui/css/layui.css">
  <script src="layui/layui.js"></script>
</head>
<body>
<div class="layui-container">
 <%-- <div class="layui-row">
    <div class="layui-col-lg12">
      <form class="layui-form" action="#">

        <div class="layui-form-item">
          <label class="layui-form-label">MESSAGE</label>
          <div class="layui-input-block">
            <input type="text" id="chat"  autocomplete="off" class="layui-input">
          </div>
        </div>
        <div class="layui-form-item">
          <div class="layui-input-block">
            <button class="layui-btn" onclick="Chat.sendMessage()">
              <i class="layui-icon">&#xe609;</i>
            </button>
          </div>
        </div>
      </form>
    </div>

  </div>--%>
  <div class="layui-row">
    <div  class="layui-col-lg12">
      <div class="layui-collapse" id="console">
        <div class="layui-colla-item">
          <h2 class="layui-colla-title">发送信息</h2>
          <div class="layui-colla-content layui-show">
            <form class="layui-form" action="#">

              <div class="layui-form-item">
                <div class="layui-inline " style="width:65%">
                  <label class="layui-form-label">MESSAGE</label>
                  <div class="layui-input-inline" style="width:70%;">
                    <input type="text" id="chat"  autocomplete="off" class="layui-input">
                  </div>
                </div>

                <div class="layui-inline">
                  <div class="layui-input-inline" >
                    <button class="layui-btn" onclick="Chat.sendMessage()">
                      <i class="layui-icon">&#xe609;</i>
                    </button>
                  </div>

                </div>
              </div>
            </form>

          </div>
        </div>

        <div class="layui-colla-item">
          <h2 class="layui-colla-title">聊天内容</h2>
          <div class="layui-colla-content layui-show" id="message_box">
          </div>
        </div>
      </div>

    </div>
  </div>

</div>
</body>
<script type="application/javascript">
    var Chat = {};

    Chat.socket = null;

    Chat.connect = (function(host) {
        if ('WebSocket' in window) {
            Chat.socket = new WebSocket(host);
        } else if ('MozWebSocket' in window) {
            Chat.socket = new MozWebSocket(host);
        } else {
            Console.log('Error: WebSocket is not supported by this browser.');
            return;
        }

        Chat.socket.onopen = function () {
            layui.use('layer', function(){
                var layer = layui.layer;

                layer.msg('WebSocket已连接!',{time:2000,icon:6});
            });
        };

        Chat.socket.onclose = function () {
            document.getElementById('chat').onkeydown = null;
            layer.msg('WebSocket已关闭!',{time:2000,icon:1});
        };

        Chat.socket.onmessage = function (message) {
            Console.log(message.data);
        };
    });



    Chat.initialize = function() {
        if (window.location.protocol == 'http:') {
            Chat.connect('ws://' + window.location.host + '/examples/websocket/chat');
        } else {
            Chat.connect('wss://' + window.location.host + '/examples/websocket/chat');
        }
    };
    Chat.initialize();

    /**
     * 点击发送按钮触发此函数，获取输入框中的内容并发送到后端
     * @type {Function}
     */
    Chat.sendMessage = (function() {
        var message = document.getElementById('chat').value;
        if (message != '') {
            Chat.socket.send(message);
            document.getElementById('chat').value = '';
        }
        return false;
    });

    var Console = {};

    Console.log = (function(message) {
        var message_box = document.getElementById('message_box');
        message_box.innerHTML = message_box.innerHTML + "</br>"+message;
        message_box.scrollTop = message_box.scrollHeight;
    });



    window.onunload = function(){
        Chat.socket.close();
    }

</script>
</html>
