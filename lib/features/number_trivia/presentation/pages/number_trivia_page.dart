import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:number_trivia/features/number_trivia/presentation/viewmodel/number_trivia_view_model.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:provider/provider.dart';


class NumberTriviaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NumberTriviaState();
  }
}

class _NumberTriviaState extends State<NumberTriviaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              Container(
                child: ((() {
                  NumberTriviaState state = Provider.of<NumberTriviaViewModel>(context).state;
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return Placeholder();
                  }
                }())),
              ),

              SizedBox(height: 20),
              // Bottom half
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}