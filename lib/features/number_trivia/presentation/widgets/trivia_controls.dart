import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/viewmodel/number_trivia_view_model.dart';
import 'package:provider/provider.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // TextField
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              // Search concrete button
              child: ElevatedButton(
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              // Search concrete button
              child: ElevatedButton(
                child: Text('Random'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    Provider.of<NumberTriviaViewModel>(context, listen: false).getConcreteNumber(controller.text);
    controller.clear();
  }

  void dispatchRandom() {
    Provider.of<NumberTriviaViewModel>(context, listen: false).getRandomNumber();
    controller.clear();
  }
}
