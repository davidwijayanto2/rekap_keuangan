// static Future<bool> sendFcmMessage(String title, String message) async {
//   try {

//     var url = 'https://fcm.googleapis.com/fcm/send';
//     var header = {
//       "Content-Type": "application/json",
//       "Authorization":
//           "key=your_server_key",
//     };
//     var request = {
//       "notification": {
//         "title": title,
//         "text": message,
//         "sound": "default",
//         "color": "#990000",
//       },
//       "priority": "high",
//       "to": "/topics/all",
//     };

//     var client = new Client();
//     var response =
//         await client.post(url, headers: header, body: json.encode(request));
//     return true;
//   } catch (e, s) {
//     print(e);
//     return false;
//   }
// }
