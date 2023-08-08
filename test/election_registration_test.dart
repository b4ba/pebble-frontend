import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Election data should be serialized correctly', () {
    final electionData = ElectionData(choices: ['Choice1', 'Choice2']);
    final serializedData = serializeElectionData(electionData);
    expect(serializedData, '{"choices": ["Choice1", "Choice2"]}');
  });

  test('API call should handle election registration responses correctly', () {
    final mockApi = MockApi();
    when(mockApi.registerToElection(any)).thenReturn(successResponse);
    final response = registerToElection(mockApi, 'Choice1');
    expect(response, isTrue);
  });

  testWidgets('Election registration form should capture choices correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(ElectionForm());
    await tester.tap(find.text('Choice1'));
    await tester.tap(find.byType(RaisedButton));
    expect(find.text('Choice1'), findsOneWidget);
  });
}
