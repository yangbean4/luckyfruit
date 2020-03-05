import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:luckyfruit/utils/aes_util.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart';

class Service {
  static final Service _instance = Service._internal();
  // final String baseUrl = 'http://yapi.demo.qunar.com/mock/33662';
  final String baseUrl = 'http://slots.plandog.com/public/index.php?r=';

  final _aes = new AESUtil(App.AESKEY);

  Dio _client;

  factory Service() => _instance;

  Service._internal() {
    if (_client == null) {
      _createClient();
    }
  }

  Future<Map<String, dynamic>> getUtilAjax(
      String url, Map<String, dynamic> data) async {
    Response response = await _client.post(url, data: data);
    return response.data;
  }

  /// 获取用户信息
  Future<User> getUser(Map<String, dynamic> data) async {
    Response response = await _client.post('/User/index', data: data);
    Map<String, dynamic> json = response.data['data'];
    return User.fromJson(json);
  }

  // 埋点 上报
  Future<Map<String, dynamic>> burialReport(Map<String, dynamic> data) async {
    Response response = await _client.post('/Report/log', data: data);
    return response.data;
  }

  /// 创建dio请求对象
  _createClient() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
        responseType: ResponseType.plain,
        receiveTimeout: 10000);

    // 创建请求对象
    _client = new Dio(options);

    // (_client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.findProxy = (Uri) {
    //     // 用1个开关设置是否开启代理
    //     // return "PROXY 10.200.14.199:8989";
    //     return 'PROXY 10.200.10.61:8888';//周治荣
    //   };
    // };

    // _client.transformer = Transformer()

    // 添加拦截器
    _client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.data = _aes.encrypt(json.encode(options.data));
      // 请求拦截器，加密参数
      return options;
    }, onResponse: (Response res) {
      final request = res.request;
      // if (request.path == '/User/taskListEncrypt') {
      String str = _aes.decrypt(res.data.toString());
      print(str);
      res.data = json.decode(str);
      // } else {
      //   res.data = json.decode(res.data);
      // }
      print('请求路径:${request.path}');
      print('请求参数:${request.data}');
      print('返回数据：${res.data}');

      Map<String, dynamic> a = res.data;

      if (a['code'] != 0) {
        return _client.reject(a['msg']);
      }
      return res;
    }, onError: (DioError e) {
      print('发生错误：' + e.message);
      print('请求路径:${e.request.path}');
      print('请求参数:${e.request.data}');
      if (e.request.path == '/Report/log') {
        return null;
      }
      if (e.message.startsWith('SocketException') ||
          // e.message.startsWith('') ||
          e.message.startsWith('Connecting timed')) {
        return Layer.toastWarning('Network disconnection, please try again');
      }
      Layer.toastWarning(e.message);
    }));
  }
}
