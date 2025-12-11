import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:decora/src/features/cart/bloc/cart_bloc.dart';
import 'package:decora/src/features/cart/bloc/cart_event.dart';
import 'package:decora/src/features/cart/bloc/cart_state.dart';
import 'package:decora/src/features/cart/service/service.dart';
import 'package:decora/src/features/product_details/models/product_model.dart';



void main() {
  late CartBloc bloc;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    bloc = CartBloc(mockRepository);
  });

  group('🧠 CartBloc Integration Tests', () {
    test('LoadPersonalCart → loads items from repository', () async {
      when(() => mockRepository.getPersonalCartProducts()).thenAnswer(
        (_) async => [
          {
            'product': Product(
              id: '1',
              name: 'Chair',
              extraInfo: 'Wooden',
              details: 'Nice chair',
              price: 100,
              discount: 10,
              quantity: 5,
              isNewCollection: false,
              category: 'furniture',
              colors: [],
              comments: [], 
            ),
            'quantity': 2,
          },
        ],
      );

      bloc.add(LoadPersonalCart());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CartState>().having((s) => s.loading, 'loading', true),
          isA<CartState>()
              .having((s) => s.loading, 'loading', false)
              .having((s) => s.items.length, 'items', 1),
        ]),
      );
    });

    test('LoadCartTotalsEvent → emits updated totals', () async {
  // Arrange: set initial state with some items
  final items = [
    {
      'product': Product(id: '1', price: 100.0, discount: 10, name: 'Test', extraInfo: '', details: '', quantity: 7, isNewCollection: false , category: '', colors: [], comments: []),
      'quantity': 2,
    },
  ];

  bloc.emit(CartState(items: items)); // set initial items

  // Act
  bloc.add(LoadCartTotalsEvent());

  // Assert
  await expectLater(
    bloc.stream,
    emitsInOrder([
      isA<CartState>()
          .having((s) => s.initialTotal, 'initialTotal', 200.0)
          .having((s) => s.discountedTotal, 'discountedTotal', 180.0),
    ]),
  );
});
  });
}


class MockCartRepository extends Mock implements CartRepository {}