import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:number_trivia/injection_container.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaViewModel extends ChangeNotifier {
  final getConcreteNumberUseCase = inject<GetConcreteNumberTrivia>();
  final getRandomNumberUseCase = inject<GetRandomNumberTrivia>();
  final inputConverter = inject<InputConverter>();

  NumberTriviaState _state = Empty();

  NumberTriviaState get state {
    return _state;
  }

  getConcreteNumber(String input) async {
    updateState(Loading());

    final either = inputConverter.stringToUnsignedInteger(input);
    either.fold((failure) {
      updateState(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (integer) async {
      final result = await getConcreteNumberUseCase(Params(number: integer));
      _eitherLoadedOrErrorState(result);
    });
  }

  getRandomNumber() async {
    updateState(Loading());

    final result = await getRandomNumberUseCase(NoParams());
    _eitherLoadedOrErrorState(result);
  }

  void updateState(NumberTriviaState state) {
    _state = state;
    notifyListeners();
  }

  void _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async {
    failureOrTrivia.fold(
      (failure) {
        updateState(Error(message: _mapFailureToMessage(failure)));
      },
      (trivia) {
        updateState(Loaded(trivia: trivia));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
