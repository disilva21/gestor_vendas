import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';

class CustomWidget extends StatefulWidget {
  final CancelFunc? cancelFunc;
  final String? texto;

  const CustomWidget({Key? key, this.cancelFunc, this.texto}) : super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  bool loveMe = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
                icon: const Icon(Icons.favorite),
                color: loveMe ? Colors.redAccent : Colors.grey,
                onPressed: () {
                  setState(() {
                    loveMe = !loveMe;
                    BotToast.showText(onlyOne: true, text: loveMe ? "Yes, I love you.😘" : "No!!!!😫");
                  });
                }),
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            color: loveMe ? Colors.redAccent : Colors.grey,
            onPressed: widget.cancelFunc,
          )
        ],
      ),
    );
  }
}


// Como Chamar

// await BotToast.showCustomNotification(
//     animationDuration: Duration(milliseconds: animationMilliseconds),
//     animationReverseDuration: Duration(milliseconds: animationReverseMilliseconds),
//     duration: Duration(seconds: seconds),
//     backButtonBehavior: backButtonBehavior,
//     toastBuilder: (cancel) {
//       return CustomWidget(
//         cancelFunc: cancel,
//       );
//     },
//     enableSlideOff: enableSlideOff,
//     onlyOne: onlyOne,
//     crossPage: crossPage);