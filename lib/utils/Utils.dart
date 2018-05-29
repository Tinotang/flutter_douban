import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
const utils_platform = const MethodChannel('samples.flutter.io/utils');

//分享按钮
class ShareIconButton extends StatelessWidget {
  ShareIconButton({this.title, this.url, this.summary});

  final String title;
  final String url;
  final String summary;
  _shareAndroid(BuildContext context) async {
    bool isSuccess=await utils_platform.invokeMethod('ShareToThis', [title, url, summary]);
    if(!isSuccess){
      _showDialog(context: context,content: '分享失败!');
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new IconButton(
        icon: new Icon(Icons.share), onPressed: (){
          if(defaultTargetPlatform==TargetPlatform.iOS){
            _showDialog(context: context,
            content: '目前分享功能不支持IOS系统');
          }else{
            _shareAndroid(context);
          }
    });
  }
}

//加载网页按钮
class WebIconButton extends StatelessWidget{
  WebIconButton({@required this.url,this.errorTip});
  final String url;
  final String errorTip;

  _openByWeb(BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
       _showDialog(context:context,content: errorTip?? '无法加载此网页!');

    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new IconButton(icon: new Icon(Icons.web), onPressed:(){ _openByWeb(context);});
  }

}

_showDialog({@required BuildContext context, String content}) {
  assert(context != null);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('提示'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//捐献按钮
class DonateFlatButton extends StatelessWidget {
  DonateFlatButton({@required this.ercode,this.text});
  final String ercode;
  final String text;

  _donateAndroid(BuildContext context) async {
    bool isSuccess=await utils_platform.invokeMethod('DonateToMe', [ercode]);
    if(!isSuccess){
      _showDialog(context: context,content: '不支持该功能或未下载支付宝');
    }
  }
  @override
  Widget build(BuildContext context) {
    return new FlatButton(onPressed:(){_donateAndroid(context);} , child: new Text(text));
  }
}

class EmailText extends StatelessWidget{
  EmailText({@required this.email,this.title,this.body});
  final String email;
  final String title;
  final String body;

  _SendEmail(){
    String emailCode='mailto:${email??''}?subject=${title??''}&body=${body??''}';
    launch(emailCode);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: _SendEmail,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('E-mail:',style: Theme.of(context).textTheme.subhead,),
            new Text(email,style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.lightBlue,),),
          ],
        ),);
  }
}

class QQCallText extends StatelessWidget {
  QQCallText({@required this.qqNumber});
  final String qqNumber;
  _CallQQ(BuildContext context) async{
     bool isSuccess= await utils_platform.invokeMethod('QQCallMe', [qqNumber]);
       if(!isSuccess){
         _showDialog(context: context,content: '不支持该功能或未下载QQ');
       }
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap:(){_CallQQ(context);} ,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('QQ:',style: Theme.of(context).textTheme.subhead,),
          new Text(qqNumber,style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.lightBlue,),),
        ],
      ),);
  }
}





