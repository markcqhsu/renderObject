import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
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
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.orange[100],
        child: ShadowBox(
          distance: 2.0,
          child: Icon(
            Icons.category,
            size: 100,
          ),
          // child: FlutterLogo(
          //   size: 100,
          // ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ShadowBox extends SingleChildRenderObjectWidget {
  final double distance;

  ShadowBox({Widget child, this.distance}) : super(child: child);

  //因為繼承了SingleChildRenderObjectWidget, 所以可以直接傳給child

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderShadowBox(distance);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderShadowBox renderObject) {
    renderObject.distance = distance;
  }
}

class RenderShadowBox extends RenderProxyBox with DebugOverflowIndicatorMixin {
// class RenderShadowBox extends RenderBox with RenderObjectWithChildMixin{
  //RenderObjectWithChildMixin使用這個是因為可以支持一個child

  // final double distance;
  double distance; //因為updateRenderObje ct會去修改distance, 所以就不會是final

  RenderShadowBox(this.distance);

  @override
  //處理佈局
  void performLayout() {
    child.layout(constraints, parentUsesSize: true);
    //parentUsesSize：Layout完這個child之後, 我作為parent我需要知道你的尺寸是多少, 我會使用你的尺寸

    // child.layout(constraints);
    // child.layout(BoxConstraints.tight(Size(50, 50)));

    // size = Size(300, 300);
    size = (child as RenderBox).size; //relayout boundary
  }

  @override
  //處理繪製
  void paint(PaintingContext context, Offset offset) {
    print(offset);
    // context.paintChild(child, offset + Offset(20, 120));//最好用加的
    context.paintChild(child, offset); //最好用加的

    context.pushOpacity(offset, 127, (context, offset) {
      //開一個半透明圖層
      context.paintChild(child, offset + Offset(distance, distance)); //最好用加的
    });

    paintOverflowIndicator(
      context,
      offset,
      offset & size,
      // Offset.zero & size,
      // Rect.fromLTWH(0, 0, size.width, size.height),
      offset & child.size,
      // Rect.fromLTWH(0, 0, 320, 320),
    );
  }
}
