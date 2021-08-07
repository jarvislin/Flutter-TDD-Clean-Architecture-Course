import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecase/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:number_trivia/features/number_trivia/presentation/viewmodel/number_trivia_view_model.dart';

final inject = GetIt.instance;

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  setUpAll(() {
    setUpInjection();
    inject.allowReassignment = true;
  });

  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia =
      MockGetConcreteNumberTrivia();
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia =
      MockGetRandomNumberTrivia();
  MockInputConverter mockInputConverter = MockInputConverter();

  inject.registerLazySingleton<GetConcreteNumberTrivia>(
          () => mockGetConcreteNumberTrivia);
  inject.registerLazySingleton<GetRandomNumberTrivia>(
          () => mockGetRandomNumberTrivia);
  inject.registerLazySingleton<InputConverter>(() => mockInputConverter);

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        viewModel.getConcreteNumber(tNumberString);
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        expect(viewModel.state, Empty());
        // act
        viewModel.getConcreteNumber(tNumberString);

        // assert
        expect(viewModel.state, Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        viewModel.getConcreteNumber(tNumberString);
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        expect(viewModel.state, Empty());
        // act
        viewModel.getConcreteNumber(tNumberString);

        // assert
        expect(viewModel.state, Loading());
        await untilCalled(mockGetConcreteNumberTrivia(any));
        expect(viewModel.state, Loaded(trivia: tNumberTrivia));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        expect(viewModel.state, Empty());
        // act
        viewModel.getConcreteNumber(tNumberString);

        // assert
        expect(viewModel.state, Loading());
        await untilCalled(mockGetConcreteNumberTrivia(any));
        expect(viewModel.state, Error(message: SERVER_FAILURE_MESSAGE));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
            // arrange
            NumberTriviaViewModel viewModel = NumberTriviaViewModel();
            setUpMockInputConverterSuccess();
            when(mockGetConcreteNumberTrivia(any))
                .thenAnswer((_) async => Left(CacheFailure()));

            expect(viewModel.state, Empty());
            // act
            viewModel.getConcreteNumber(tNumberString);

            // assert
            expect(viewModel.state, Loading());
            await untilCalled(mockGetConcreteNumberTrivia(any));
            expect(viewModel.state, Error(message: CACHE_FAILURE_MESSAGE));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the concrete use case',
          () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        viewModel.getRandomNumber();
        // assert
        verify(mockGetRandomNumberTrivia.call(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        expect(viewModel.state, Empty());
        // act
        viewModel.getRandomNumber();

        // assert
        expect(viewModel.state, Loading());
        await untilCalled(mockGetRandomNumberTrivia(any));
        expect(viewModel.state, Loaded(trivia: tNumberTrivia));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
          () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        expect(viewModel.state, Empty());
        // act
        viewModel.getRandomNumber();

        // assert
        expect(viewModel.state, Loading());
        await untilCalled(mockGetRandomNumberTrivia(any));
        expect(viewModel.state, Error(message: SERVER_FAILURE_MESSAGE));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () async {
        // arrange
        NumberTriviaViewModel viewModel = NumberTriviaViewModel();
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        expect(viewModel.state, Empty());
        // act
        viewModel.getRandomNumber();

        // assert
        expect(viewModel.state, Loading());
        await untilCalled(mockGetRandomNumberTrivia(any));
        expect(viewModel.state, Error(message: CACHE_FAILURE_MESSAGE));
      },
    );
  });
}

void setUpInjection() {
  inject.registerSingleton(() => GetConcreteNumberTrivia(inject()));
  inject.registerSingleton(() => GetRandomNumberTrivia(inject()));
  inject.registerSingleton(() => InputConverter());
}
