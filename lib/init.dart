import 'package:chatify/cacheManager/hive.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/pages/messages/messages.get.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'models/message.dart';
import 'models/room.dart';
import 'models/user.dart';
import 'pages/chat/chat.get.dart';

class AppInit {
  static final AppInit _singleton = AppInit._internal();
  factory AppInit() {
    return _singleton;
  }
  AppInit._internal();

  IO.Socket? socket;
  User? currentChatUser;
  Room? currentChatRoom;

  void initSocketClient() {
    AppInit().socket = IO.io(
        '${Config.socketServerBaseUrl}?token=${Config.me!.token}',
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .enableForceNew()
            .build());

    AppInit().socket?.on('onMessage', (data) => _onMessageHandler(data));

    AppInit().socket?.connect();
  } // end socket client initialization

  _onMessageHandler(Map<String, dynamic> json) {
    final messagesGet = Get.find<MessagesGet>();
    final message = Message(
        date: DateTime.now(),
        message: json['message'],
        roomId: json['roomId'] ?? '',
        user: User.fromSocketJson(json['from']));
    if (message.roomId != '' && message.user.id == Config.me!.userId) return;
    if ((message.user.id == currentChatUser?.id && message.roomId == '') ||
        (message.roomId == currentChatRoom?.id)) {
      try {
        final chatGet = Get.find<ChatGet>();
        message.seen = true; // when user is inside chat page
        chatGet.messages.add(message);
        chatGet.onUpdateStream.sink.add(true);
      } catch (er) {
        print(er);
      }
    }
    if (message.roomId == '') {
      HiveCacheManager().update(message.user.id, message);
      messagesGet.contactsStream.sink.add(true);
    } else {
      HiveCacheManager().updateRoom(message.roomId, message);
      messagesGet.roomStream.sink.add(true);
    }
  }
}
