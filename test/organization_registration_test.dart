import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Data should be serialized correctly', () {
    final user = User(publicKey: 'sampleKey');
    final serializedData = serializeUserData(user);
    expect(serializedData, '{"publicKey": "sampleKey"}');
  });

  test('API call should handle responses correctly', () {
    final mockApi = MockApi();
    when(mockApi.registerToOrganization(any)).thenReturn(successResponse);
    final response = registerToOrganization(mockApi, 'sampleKey');
    expect(response, isTrue);
  });

  testWidgets('Registration form should capture data correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(RegistrationForm());
    await tester.enterText(find.byType(TextField), 'sampleKey');
    await tester.tap(find.byType(RaisedButton));
    expect(find.text('sampleKey'), findsOneWidget);
  });
}
