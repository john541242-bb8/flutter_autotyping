import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keypress_simulator/keypress_simulator.dart';

void main() {
  runApp(MaterialApp(home: AutoTyping()));
}

class AutoTyping extends StatefulWidget {
  const AutoTyping({super.key});

  @override
  State<AutoTyping> createState() => _AutoTypingState();
}

class _AutoTypingState extends State<AutoTyping> {
  //為了注重效率，提前做了一個可能會用到的key列表，最大化查找效率。
  //不在使用key.debugname，因為這個東西在release中不存在，改用key.usbHidUsage
  // List<PhysicalKeyboardKey> commonlykeys = [];
  // void defindCKeysList() {
  //   for (var key in PhysicalKeyboardKey.knownPhysicalKeys) {
  //     if (key.usbHidUsage >= 0x70004 && key.usbHidUsage <= 0x7001D) {
  //       commonlykeys.add(key);
  //     } else if (key.usbHidUsage >= 0x62 && key.usbHidUsage <= 0x61) {
  //       commonlykeys.add(key);
  //     }
  //   }
  // }

  final Map<String, PhysicalKeyboardKey> charToKey = {
    // 字母
    'a': PhysicalKeyboardKey.keyA,
    'b': PhysicalKeyboardKey.keyB,
    'c': PhysicalKeyboardKey.keyC,
    'd': PhysicalKeyboardKey.keyD,
    'e': PhysicalKeyboardKey.keyE,
    'f': PhysicalKeyboardKey.keyF,
    'g': PhysicalKeyboardKey.keyG,
    'h': PhysicalKeyboardKey.keyH,
    'i': PhysicalKeyboardKey.keyI,
    'j': PhysicalKeyboardKey.keyJ,
    'k': PhysicalKeyboardKey.keyK,
    'l': PhysicalKeyboardKey.keyL,
    'm': PhysicalKeyboardKey.keyM,
    'n': PhysicalKeyboardKey.keyN,
    'o': PhysicalKeyboardKey.keyO,
    'p': PhysicalKeyboardKey.keyP,
    'q': PhysicalKeyboardKey.keyQ,
    'r': PhysicalKeyboardKey.keyR,
    's': PhysicalKeyboardKey.keyS,
    't': PhysicalKeyboardKey.keyT,
    'u': PhysicalKeyboardKey.keyU,
    'v': PhysicalKeyboardKey.keyV,
    'w': PhysicalKeyboardKey.keyW,
    'x': PhysicalKeyboardKey.keyX,
    'y': PhysicalKeyboardKey.keyY,
    'z': PhysicalKeyboardKey.keyZ,

    // 數字
    '0': PhysicalKeyboardKey.digit0,
    '1': PhysicalKeyboardKey.digit1,
    '2': PhysicalKeyboardKey.digit2,
    '3': PhysicalKeyboardKey.digit3,
    '4': PhysicalKeyboardKey.digit4,
    '5': PhysicalKeyboardKey.digit5,
    '6': PhysicalKeyboardKey.digit6,
    '7': PhysicalKeyboardKey.digit7,
    '8': PhysicalKeyboardKey.digit8,
    '9': PhysicalKeyboardKey.digit9,
    // //特殊字元(不搭配shift)
    // ' ': PhysicalKeyboardKey.space,
    // ',': PhysicalKeyboardKey.comma,
    // '.': PhysicalKeyboardKey.period,
    // "'": PhysicalKeyboardKey.quote,
    // '-': PhysicalKeyboardKey.minus,
    // ';': PhysicalKeyboardKey.semicolon,
    // //換行符
    // "^": PhysicalKeyboardKey.enter,
  };

  Future<void> realTyping(String text, Duration delay) async {
    for (var char in text.characters) {
      if (stopTyping) {
        stopTyping = false;
        return;
      }
      PhysicalKeyboardKey? key = charToKey[char.toLowerCase()];

      //檢查英文字母
      if (key != null) {
        bool isup = isUpperWord(char) && isLetter(char);
        if (isup) {
          keyPressSimulator.simulateKeyDown(
            PhysicalKeyboardKey.shiftLeft,
          );
          keyPressSimulator.simulateKeyDown(key);
          await Future.delayed(Duration(milliseconds: 10));

          keyPressSimulator.simulateKeyUp(key);

          keyPressSimulator.simulateKeyUp(
            PhysicalKeyboardKey.shiftLeft,
          );
        } else {
          typing(key);
        }
        print("這個key是$key，他是大寫還是小寫 $isup");
      } else {
        //特殊字元情況
        if (char == " ") {
          await typing(PhysicalKeyboardKey.space);
        } else if (char == ",") {
          await typing(PhysicalKeyboardKey.comma);
        } else if (char == ".") {
          await typing(PhysicalKeyboardKey.period);
        } else if (char == "'") {
          await typing(PhysicalKeyboardKey.quote);
        } else if (char == "-") {
          await typing(PhysicalKeyboardKey.minus);
        } else if (char == ";") {
          await typing(PhysicalKeyboardKey.semicolon);
        } else if (char == ":") {
          await typingWithShift(PhysicalKeyboardKey.semicolon);
        } else if (char == "(") {
          await typingWithShift(PhysicalKeyboardKey.digit9);
        } else if (char == ")") {
          await typingWithShift(PhysicalKeyboardKey.digit0);
        } else if (char == "?") {
          await typingWithShift(PhysicalKeyboardKey.slash);
        } else if (char == "!") {
          await typingWithShift(PhysicalKeyboardKey.digit1);
        } else if (char == '"') {
          await typingWithShift(PhysicalKeyboardKey.quote);
        } else if (char == "(") {
          await typingWithShift(PhysicalKeyboardKey.digit9);
        } else if (char == ")") {
          await typingWithShift(PhysicalKeyboardKey.digit0);
        } else if (char == "?") {
          await typingWithShift(PhysicalKeyboardKey.slash);
        } else if (char == "!") {
          await typingWithShift(PhysicalKeyboardKey.digit1);
        } else if (char == '"') {
          await typingWithShift(PhysicalKeyboardKey.quote);
        }
        //換行符
        if (char == "^") {
          print("按下換行了");
          await typing(PhysicalKeyboardKey.enter);
          continue;
        }
      }

      // for (var key in commonlykeys) {
      //   if (key.usbHidUsage == charToKey[char.toUpperCase()]) {
      //     //檢查是否為大寫
      //     if (isup) {
      // keyPressSimulator.simulateKeyDown(
      //   PhysicalKeyboardKey.shiftLeft,
      // );
      // keyPressSimulator.simulateKeyDown(key);
      // await Future.delayed(Duration(milliseconds: 20));

      // keyPressSimulator.simulateKeyUp(key);

      // keyPressSimulator.simulateKeyUp(
      //   PhysicalKeyboardKey.shiftLeft,
      // );
      //       // typingWithShift(key);
      //     } else {
      //       //小寫
      //       typing(key);
      //     }
      //     print("$key 他是 大寫還是小寫 $isup");
      //     continue;
      //   } else if (key.usbHidUsage == charToKey[char]) {
      //     //數字
      //     await typing(key);
      //     print("$key 是個數字");
      //     continue;
      //   }
      // }

      await Future.delayed(delay);
    }
  }

  Future<void> typing(PhysicalKeyboardKey typingkey) async {
    keyPressSimulator.simulateKeyDown(typingkey);
    await Future.delayed(Duration(milliseconds: 10));
    keyPressSimulator.simulateKeyUp(typingkey);
  }

  //因為處理的程式為毫秒等級，如果在這按下shift的情況下把它變成外部方法，(可能)會造成電腦反應不過來。(我優化了!!!)
  Future<void> typingWithShift(PhysicalKeyboardKey key) async {
    keyPressSimulator.simulateKeyDown(PhysicalKeyboardKey.shiftLeft);
    keyPressSimulator.simulateKeyDown(key);
    await Future.delayed(Duration(milliseconds: 10));

    keyPressSimulator.simulateKeyUp(key);

    keyPressSimulator.simulateKeyUp(PhysicalKeyboardKey.shiftLeft);
  }

  bool isUpperWord(String word) {
    return word == word.toUpperCase();
  }

  bool isLetter(String char) {
    final regExp = RegExp(r'[a-zA-Z]');
    return regExp.hasMatch(char);
  }

  String addEntertoText(String text) {
    final wordPattern = RegExp(r'[\r\n]+');
    return text.replaceAll(wordPattern, r"^");
  }

  final targetTextController = TextEditingController();
  final waitDelayTextCon = TextEditingController();
  int waitDelay = 5; //等待開始打字的時間
  double typingSpeed = 10; //每一個字的間隔(單位：毫秒)
  // num lastSencond = 0;
  String displayText = "";
  String buttomText = "點我開始打字";
  bool stopTyping = false;
  bool nowistyping = false;
  bool waitTimeError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // defindCKeysList();
    waitDelayTextCon.text = "$waitDelay";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("自動化打字程式", style: TextStyle(fontFamily: "Cubic")),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/cat_on_keyborad.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.7), // 越接近白色，越淡
              BlendMode.modulate,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              color: Colors.white.withValues(alpha: 0.5),
              child: Container(
                margin: EdgeInsetsDirectional.all(5),
                child: Text(
                  "目前是每${typingSpeed.floor()}毫秒打一個字",
                  style: TextStyle(
                    fontFamily: "Cubic",
                    fontSize: 20,
                    // backgroundColor: Colors.white.withValues(
                    //   alpha: 0.5,
                    // ),
                    letterSpacing: 8,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("1毫秒"), Text("100毫秒")],
                  ),
                ),
                Slider(
                  value: typingSpeed,
                  thumbColor: Colors.orange,
                  activeColor: Colors.orange,
                  min: 1,
                  max: 100,

                  onChanged: (value) {
                    setState(() {
                      typingSpeed = value;
                    });
                  },
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: targetTextController,
                style: TextStyle(fontFamily: "MapleMono"),
                cursorWidth: 2,
                cursorRadius: Radius.circular(20),
                cursorColor: Colors.orange,
                minLines: 7,
                maxLines: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.4),
                  hintText: "輸入你想要打的文字",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 5.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: TextField(
                controller: waitDelayTextCon,
                textAlign: TextAlign.center,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red.withValues(alpha: 0.2),
                  label: Text(
                    "按下按鈕後等待的秒數",
                    style: TextStyle(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 5,
                    ),
                  ),
                ),
                // textInputAction: TextInputAction.done,
                // onEditingComplete: () {
                //   if (waitDelayTextCon.text.trim().isEmpty) {
                //     print("竟然是空值，我要改變!!");
                //     waitDelayTextCon.text == "5";
                //     print(waitDelayTextCon.text);
                //   }
                // },
                onChanged: (text) {
                  try {
                    waitDelay = int.parse(text);
                    waitTimeError = false;
                    setState(() {
                      displayText = '';
                    });
                  } catch (e) {
                    print(e);
                    setState(() {
                      waitTimeError = true;
                      displayText = '等待數字必須是個"數值"';
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!waitTimeError) {
                  if (!nowistyping) {
                    nowistyping = true;
                    setState(() {
                      buttomText = "按一下我停止";
                    });

                    for (var i = waitDelay; i > 0; i--) {
                      if (stopTyping) {
                        setState(() {
                          stopTyping = false;
                        });
                        return;
                      }
                      setState(() {
                        displayText = "目前還有${i}秒就要開始打字囉";
                      });
                      await Future.delayed(Duration(seconds: 1));
                    }
                    setState(() {
                      displayText = "正在打字!!";
                    });

                    await realTyping(
                      addEntertoText(targetTextController.text),
                      Duration(
                        milliseconds: typingSpeed.floor().toInt(),
                      ),
                    );

                    setState(() {
                      nowistyping = false;
                      displayText = "";
                      buttomText = "點我開始打字";
                    });
                  } else {
                    setState(() {
                      nowistyping = false;
                      stopTyping = true;
                      displayText = "";
                      buttomText = "已暫停";
                    });
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      buttomText = "點我開始打字";
                    });
                  }
                  print("Done");
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.orange[900],
                shadowColor: Colors.orange[700],
                backgroundColor: Colors.orange,
              ),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  buttomText,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            Text(
              displayText,
              style: TextStyle(
                fontFamily: "Cubic",
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "(使用者小提醒：等待秒數越低可能會越多錯字喔，有些電腦的處理速度沒那麼快)",
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
