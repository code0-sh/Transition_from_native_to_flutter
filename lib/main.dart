import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native&Flutter View',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      routes: {
        '/': (context) => const InitialPage(),
        '/top': (context) => const TopPage(),
      },
    );
  }
}

class InitialPage extends StatelessWidget {
  static const routeName = "/";
  static const MethodChannel channel = MethodChannel("channel");

  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'setup':
          return Navigator.pushNamedAndRemoveUntil(
            context,
            TopPage.routeName,
            (route) => route.isFirst,
          );
        default:
          return Navigator.pushNamedAndRemoveUntil(
            context,
            TopPage.routeName,
            (route) => route.isFirst,
          );
      }
    });
    return const TopPage();
  }
}

class TopPage extends StatelessWidget {
  static const routeName = "/top";
  const TopPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                const channel = MethodChannel('channel');
                await channel.invokeMethod('backNative');
              },
              child: const Text('back to native'),
            ),
            Expanded(
              child: Container(),
            ),
            const CustomScrollViewContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomScrollViewContent extends StatefulWidget {
  const CustomScrollViewContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomScrollViewContentState();
  }
}

class CustomScrollViewContentState extends State<CustomScrollViewContent> {
  final _contentKey = GlobalKey();
  double _height = 0;
  bool _visible = true;
  double _initialChildSize = 0.5;
  double _minChildSize = 0.5;

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _height = _contentKey.currentContext!.size!.height;
      });
    });
    super.initState();
  }

  void _showModalBottomSheet() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _showModalBottomSheet,
          child: const Text('show modal bottom sheet'),
        ),
        _visible
            ? Container(
                color: Colors.blue,
                child: SizedBox(
                  height: _height,
                  child: DraggableScrollableActuator(
                    child:
                        NotificationListener<DraggableScrollableNotification>(
                      onNotification: (notification) {
                        print("==extent==");
                        print(notification.extent);
                        print("==maxExtent==");
                        print(notification.maxExtent);
                        //print("==height==");
                        //print(notification.context.size?.height ?? 0);
                        return true;
                      },
                      child: DraggableScrollableSheet(
                        initialChildSize: _initialChildSize,
                        minChildSize: _minChildSize,
                        maxChildSize: 1,
                        snap: true,
                        builder: (context, scrollController) {
                          return LayoutBuilder(builder: (context, constraints) {
                            return SingleChildScrollView(
                              physics:
                                  const ClampingScrollPhysics(), // Android scroll behavior set
                              controller: scrollController,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight),
                                child: Container(
                                  key: _contentKey,
                                  padding: const EdgeInsets.all(20),
                                  color: Colors.cyan,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Text("Title"),
                                      const Text("Subtitle"),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('close'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            DraggableScrollableActuator.reset(
                                                context),
                                        child: const Text('reset'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
