import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:luckyfruit/utils/aes_util.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/config/app.dart';
// import 'package:luckyfruit/models/index.dart';

class Service {
  static final Service _instance = Service._internal();

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
    return response.data['data'];
  }

  /// 获取用户信息
  Future<Map<String, dynamic>> getUser(Map<String, dynamic> data) async {
    Response response = await _client.post('/User/index', data: data);
    return response.data['data'];
  }

  // 获取用户树数据
  Future<Map<String, dynamic>> relaRelated(Map<String, dynamic> data) async {
    Response response = await _client.post('/User/relaRelated', data: data);
    return response.data['data'];
  }

  // 获取用户树数据
  Future<Map<String, dynamic>> getTreeInfo(Map<String, dynamic> data) async {
    Response response = await _client.post('/Tree/treeInfo', data: data);
    return response.data['data'];
  }

  // 树数据记录
  Future<Map<String, dynamic>> saveTreeInfo(Map<String, dynamic> data) async {
    Response response = await _client.post('/Tree/addTree', data: data);
    return response.data['data'];
  }

  // 获取用户树数据
  Future<Map<String, dynamic>> getUserInfo(Map<String, dynamic> data) async {
    Response response = await _client.post('/User/userInfo', data: data);
    return response.data['data'];
  }

  // 获取用户树数据
  Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> data) async {
    Response response = await _client.post('/User/update', data: data);
    return response.data;
  }

  // 埋点 上报
  Future<Map<String, dynamic>> burialReport(Map<String, dynamic> data) async {
    Response response = await _client.post('/Report/log', data: data);
    return response.data['data'];
  }

  // 获取好友排行和分红树排行
  Future<Map<String, dynamic>> getRankInfo(Map<String, dynamic> data) async {
    Response response = await _client.post('/FriendsRank/getRank', data: data);
    return response.data['data'];
  }

  // 获取大转盘结果
  Future<Map<String, dynamic>> getLuckyWheelResult(
      Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Roulette/playRoulette', data: data);
    return response.data['data'];
  }

  // 获取游戏时长等相关配置数据
  Future<Map<String, dynamic>> getDefaultDeploy(
      Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Deployinfo/defaultDeploy', data: data);
    return response.data['data'];
  }

  // 获取用户升级金币数据相关
  Future<List> getCoinRule(Map<String, dynamic> data) async {
    Response response = await _client.post('/Deployinfo/coinRule', data: data);
    return response.data['data'];
  }

// 获取城市图配置
  Future<List> getcityList(Map<String, dynamic> data) async {
    Response response = await _client.post('/Deployinfo/cityList', data: data);
    return response.data['data'];
  }

  // 获取用户升级金币数据相关
  Future<Map<String, dynamic>> getDrawInfo(Map<String, dynamic> data) async {
    Response response = await _client.post('/Draw/info', data: data);
    return response.data['data'];
  }

  // 用户签到接口
  Future<Map<String, dynamic>> beginSign(Map<String, dynamic> data) async {
    Response response = await _client.post('/Draw/beginSign', data: data);
    return response.data['data'];
  }

  // 用户抽奖接口
  Future<Map<String, dynamic>> lotteryDraw(Map<String, dynamic> data) async {
    Response response = await _client.post('/Draw/lotteryDraw', data: data);
    return response.data['data'];
  }

  // 用户许愿树领奖接口
  Future<Map<String, dynamic>> wishTreeDraw(Map<String, dynamic> data) async {
    Response response = await _client.post('/Draw/wishTreeDraw', data: data);
    return response.data['data'];
  }

  // 许愿树回收接口
  Future<Map<String, dynamic>> wishTreeRecycle(
      Map<String, dynamic> data) async {
    Response response = await _client.post('/Draw/recoverWishTree', data: data);
    return response.data;
  }

  // 大转盘券添加接口
  Future<Map<String, dynamic>> addTicket(Map<String, dynamic> data) async {
    Response response = await _client.post('/Roulette/addTicket', data: data);
    return response.data;
  }

  // 种限时分红树接口
  Future<Map<String, dynamic>> plantTimeLimitTree(
      Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Dividend/plantTimeLimitTree', data: data);
    return response.data;
  }

  // 用户30/60分领取金币
  Future<Map<String, dynamic>> receiveCoin(Map<String, dynamic> data) async {
    Response response = await _client.post('/User/receiveCoin', data: data);
    return response.data['data'];
  }

  // 获取用户的Partner信息
  Future<Map<String, dynamic>> getPartnerListInfo(
      Map<String, dynamic> data) async {
    Response response = await _client.post('/Partner/getInfo', data: data);
    return response.data['data'];
  }

// 购买果树获取单价和产生金币数
  Future<Map<String, dynamic>> fruiterUnivalent(
      Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Deployinfo/fruiterUnivalent', data: data);
    return response.data['data'];
  }

  // 获取个人中心数据
  Future<Map<String, dynamic>> getPersonalInfo(
      Map<String, dynamic> data) async {
    Response response = await _client.post('/Personal/info', data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getGlobalDividendTree(
      Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Dividend/globalDividendTree', data: data);
    return response.data['data'];
  }

  // 获取好友每日贡献收益记录
  Future<Map<String, dynamic>> getPartnerProfitListInfo(
      Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Partner/getPartnerProfit', data: data);
    return response.data;
  }

  Future<List> getDeblokCityList(Map<String, dynamic> data) async {
    Response response = await _client.post('/Personal/deblokCity', data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> unlockNewCity(Map<String, dynamic> data) async {
    Response response = await _client.post('/Reward/unlockNewCity', data: data);
    return response.data['data'];
  }

  // 个人中心消息中心页面
  Future<List> messageCentre(Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Personal/messageCentre', data: data);
    return response.data['data'];
  }

  // 获取用户收益数据
  Future<List> profitLog(Map<String, dynamic> data) async {
    Response response = await _client.post('/Personal/profitLog', data: data);
    return response.data['data'];
  }

// 获取邀请人信息
  Future<Map<String, dynamic>> getinviterData(Map<String, dynamic> data) async {
    Response response = await _client.post('/Personal/inviterData', data: data);
    return response.data['data'];
  }

  //添加邀请码追溯来源
  Future<Map<String, dynamic>> inviteCode(Map<String, dynamic> data) async {
    Response response = await _client.post('/Personal/inviteCode', data: data);
    return response.data['data'];
  }

  // TODO所有的接口返回值都要看下所获取的map是否为null，是的话就不进行json序列化了
  // 用户提现
  Future<Map<String, dynamic>> withDraw(Map<String, dynamic> data) async {
    Response response = await _client.post('/user/withdarw', data: data);
    return response.data['data'];
  }

  // 树木解锁新等级,检测是否获取 [1. 限时分红树 2. 全球分红树 3. 啤酒花雌��� 4. 啤酒花雄花 5. 许愿树]
  Future<Map<String, dynamic>> unlockNewLevel(Map<String, dynamic> data) async {
    Response response =
        await _client.post('/Reward/unlockNewLevel', data: data);
    return response.data['data'];
  }

  // 用户观看广告记录
  Future<Map<String, dynamic>> videoAdsLog(Map<String, dynamic> data) async {
    Response response = await _client.post('/Video/videoLog', data: data);
    return response.data;
  }

  /// 创建dio请求对象
  _createClient() {
    BaseOptions options = BaseOptions(
        baseUrl: App.BASE_URL,
        connectTimeout: 5000,
        responseType: ResponseType.plain,
        receiveTimeout: 10000);

    // 创建请求对象
    _client = new Dio(options);

    Storage.getItem("proxy_ip").then((value) {
      print("proxy_ip specified: $value");
      if (value == null || value.length == 0) {
        return;
      }

      (_client.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        client.findProxy = (Uri) {
          // 用1个开关设置是否开启代理
          return "PROXY $value";
        };
      };
    });

    // 添加拦截器
    _client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // REVIEW: aes?
      // options.data = _aes.encrypt(json.encode(options.data));
      // 请求拦截器，加密参数
      return options;
    }, onResponse: (Response res) {
      final request = res.request;
      // if (request.path == '/User/taskListEncrypt') {
      String str = _aes.decrypt(res.data.toString());
      res.data = json.decode(str);
      // } else {
      //   res.data = json.decode(res.data);
      // }
      print('请求路径:${request.path}');
      print('请求参数:${request.data}');
      print('返回数据:${res.data}');

      // Map<String, dynamic> a = res.data;
      // if (a['code'] != 0) {
      //   return _client.reject(a['msg']);
      // }
      return res;
    }, onError: (DioError e) {
      print('发生错误:' + e.message);
      print('请求路径:${e.request.path}');
      print('请求参数:${e.request.data}');

      if (e.message.startsWith('SocketException') ||
          // e.message.startsWith('') ||
          e.message.startsWith('Connecting timed')) {
        return Layer.toastWarning('Network disconnected, try again later');
      }
      Layer.toastWarning(e.message);
    }));
  }
}
