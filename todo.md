<!--
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-03-13 10:05:06
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-04-09 20:23:36
 -->


4.2
1. bug
2. facebook + share link
3. Messenge
4. 树换图
5. 引导页
6. 三个动效
7. 城市背景图
8. 好评弹窗
9. 广告SDK
10. 埋点

--------
1. 引导       -bonan
2. 推送、好评 how to play  -bean
3. 俩弹窗
4. 弹幕



- 界面
  - 弹幕 
  - ~~双倍收益两种状态  自动合成两种状态~~    ----bean
  - ~~热气球 点击热气球后领取奖励弹窗~~   ----bean
  -  ~~礼物盒子  点击礼物盒子后领取奖励弹窗~~  1 ----bean
  - ~~图鉴界面~~ 0.5  -bonan
  - ~~排行榜界面~~ 0.5 ---bonan
  - ~~今日分红树收益提示~~
  - ~~金币产生速度模块+合成树界面+添加树模块+底部栏~~
  - ~~顶部栏~~


- 弹窗类
  - ~~领取金币弹窗（30min和60min~~ 0.5  -bonan
  - ~~合成树后随机出现的越级升级弹窗、购买树提示金币不足弹窗、离线后重新登录时的离线奖励弹窗 0.5~~ -bonan
  - ~~手机碎片弹窗~~ 1.5 --bean
  - ~~大转盘弹窗（包括奖励提示弹窗）~~—— 0.5 bonan
  - ~~限时分红树弹窗、许愿树兑换成功或者位置不足弹窗~~ 0.5 --bonan
  - ~~合成树解锁新等级（38级以上）时弹窗（包括啤酒花树+五洲树） + 38级树的特殊处理~~ 1 -bonan
  - ~~用户等级升级后提示弹窗~~ 
  - ~~仓库弹窗~~
  - ~~合成树解锁新等级（38级以下）时弹窗~~

  - 优化
    - ~~自动合成~~  bean 1.5


- 对接第三方
  - mopub
  - fb 分享 登录
  - 分享 + 追溯
  - 上线配置
  - 消息通知

3.20
  - 手机碎片抽奖时的金币处理 UI更新 -bean
  - 分红树 对接 -bonan
  - ~~get it 页面~~ 0.5 --bean
  - ~~Partner页面 + 收入/好友 明细~~ 2.5 -bonan
  - ~~map+解锁城市+ 弹窗~~ 我的全球分红树+玩法介绍 -1.5 --bean
  - ~~mine 消息中心 明细~~  - 1 -bean
  - ~~邀请码~~ 0.5 -bean
  - setting ~~提现~~  1 -bonan

再议
- ~~宝树五边形~~ -bean

- UI检查
- 逻辑检查
- 模块互测
- 动画调整
- ~~BGM~~






---------------------------------------------------

1、首页 垃圾桶回收 需要更换样式
2、背景音乐 有时会重复播放，关闭音乐后，音乐实际并未关闭，再次开启后，背景音乐有两层声音
3、树木合成时，增加一个动效
4、礼物盒子从上往下掉落速度加快，掉到树坑里时，有一个反弹或者晃动的效果。

5、弹窗出来时，有一个快速的由小变大的效果
6、树木变大时，树木产出的金币开始增加
7、双倍金币以及auto merge 出现时，先快速晃动，然后
8、双倍金币以及auto merge的倒计时应该是00:00的形式
9、树木金币增加的音效没有生效
10、instruction的布局不整齐
11、双倍金币以及auto merge图标不是很明显(龙龙处理)
12、领取手机碎片，sign up 7日登陆领取完毕后，再次进入时，sign up自定划过，跳转只每日3次领取奖励
13、3 lucky draw chances per day的动效应该先快后慢
14、大转盘每次进行转动的时候，均会进行回转？  不应该回转
15、下边的图标 间距为等比
16、captain等级数据不对，解锁果树已经到19级了  captain还在Lv5，而且也一直在城镇1
17、partner上边的区域中不是展示partner文案，文案展示不对
18、Partnerd中的Number of Friends 中的好友 界面展示不对
19、partner中的Earning from Partners中的布局不
20、Map页面布局不对，从Hawaii中点进map页面后，没有回退按钮
21、Rank排行榜动效没加




-----------------------
