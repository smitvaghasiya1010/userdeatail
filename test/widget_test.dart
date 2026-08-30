import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:userdetail/main.dart';
import 'package:userdetail/models/user.dart';
import 'package:userdetail/screens/user_detail_screen.dart';
import 'package:userdetail/screens/user_list_screen.dart';
import 'package:userdetail/services/user_service.dart';

void main() {
  const sampleUserJson = {
    'id': 1,
    'name': 'Leanne Graham',
    'username': 'Bret',
    'email': 'Sincere@april.biz',
    'address': {
      'street': 'Kulas Light',
      'suite': 'Apt. 556',
      'city': 'Gwenborough',
      'zipcode': '92998-3874',
      'geo': {'lat': '-37.3159', 'lng': '81.1496'}
    },
    'phone': '1-770-736-8031 x56442',
    'website': 'hildegard.org',
    'company': {
      'name': 'Romaguera-Crona',
      'catchPhrase': 'Multi-layered client-server neural-net',
      'bs': 'harness real-time e-markets'
    }
  };

  group('User Model Tests', () {
    test('User.fromJson parses fields correctly', () {
      final user = User.fromJson(sampleUserJson);

      expect(user.id, 1);
      expect(user.name, 'Leanne Graham');
      expect(user.username, 'Bret');
      expect(user.email, 'Sincere@april.biz');
      expect(user.phone, '1-770-736-8031 x56442');
      expect(user.website, 'hildegard.org');
      expect(user.address.street, 'Kulas Light');
      expect(user.address.suite, 'Apt. 556');
      expect(user.address.city, 'Gwenborough');
      expect(user.address.zipcode, '92998-3874');
      expect(user.address.geo.lat, '-37.3159');
      expect(user.address.geo.lng, '81.1496');
      expect(user.company.name, 'Romaguera-Crona');
      expect(user.company.catchPhrase, 'Multi-layered client-server neural-net');
      expect(user.company.bs, 'harness real-time e-markets');
    });

    test('User.initials generates correct initials for 2-word names', () {
      final user = User.fromJson(sampleUserJson);
      expect(user.initials, 'LG');
    });

    test('User.initials generates correct initials for single-word name', () {
      final user = User.fromJson(const {
        'id': 2,
        'name': 'Ervin',
        'username': 'erv',
        'email': 'erv@test.com',
      });
      expect(user.initials, 'ER');
    });

    test('Address.fullAddress formats address properly', () {
      final user = User.fromJson(sampleUserJson);
      expect(
        user.address.fullAddress,
        'Apt. 556, Kulas Light, Gwenborough, 92998-3874',
      );
    });

    test('User.toJson serializes correctly', () {
      final user = User.fromJson(sampleUserJson);
      final json = user.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Leanne Graham');
      expect(json['username'], 'Bret');
    });
  });

  group('UserService Tests', () {
    test('fetchUsers returns list of users on 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([sampleUserJson]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = UserService(client: mockClient);
      final users = await service.fetchUsers();

      expect(users.length, 1);
      expect(users.first.name, 'Leanne Graham');
    });

    test('fetchUsers throws UserServiceException on 404 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = UserService(client: mockClient);
      expect(() => service.fetchUsers(), throwsA(isA<UserServiceException>()));
    });

    test('fetchUsers throws UserServiceException on server 500 error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = UserService(client: mockClient);
      expect(() => service.fetchUsers(), throwsA(isA<UserServiceException>()));
    });
  });

  group('Widget Tests', () {
    testWidgets('App renders UserListScreen and shows loading initially', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) async {
        // Delay response to inspect loading state
        await Future.delayed(const Duration(milliseconds: 100));
        return http.Response(jsonEncode([sampleUserJson]), 200);
      });

      final service = UserService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: UserListScreen(userService: service),
        ),
      );

      // Verify AppBar title 'Users'
      expect(find.text('Users'), findsOneWidget);

      // Verify loading indicator is present before future completes
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Finish loading
      await tester.pumpAndSettle();

      // Verify user item is displayed
      expect(find.text('Leanne Graham'), findsOneWidget);
      expect(find.text('@Bret'), findsOneWidget);
      expect(find.text('Sincere@april.biz'), findsOneWidget);
      expect(find.text('LG'), findsOneWidget);
    });

    testWidgets('UserListScreen displays error state with Retry button on failure', (
      WidgetTester tester,
    ) async {
      bool shouldFail = true;

      final mockClient = MockClient((request) async {
        if (shouldFail) {
          return http.Response('Internal Server Error', 500);
        }
        return http.Response(jsonEncode([sampleUserJson]), 200);
      });

      final service = UserService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: UserListScreen(userService: service),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error state
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Tap Retry after fixing error
      shouldFail = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // Verify users are now shown
      expect(find.text('Leanne Graham'), findsOneWidget);
    });

    testWidgets('UserListScreen displays empty state when list is empty', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode([]), 200);
      });

      final service = UserService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: UserListScreen(userService: service),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No users found.'), findsOneWidget);
    });

    testWidgets('UserDetailScreen displays all user attributes accurately', (
      WidgetTester tester,
    ) async {
      final user = User.fromJson(sampleUserJson);

      await tester.pumpWidget(
        MaterialApp(
          home: UserDetailScreen(user: user),
        ),
      );

      // Verify Header
      expect(find.text('User Details'), findsOneWidget);
      expect(find.text('Leanne Graham'), findsOneWidget);
      expect(find.text('@Bret'), findsOneWidget);
      expect(find.text('LG'), findsOneWidget);

      // Verify Contact Section
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Sincere@april.biz'), findsOneWidget);
      expect(find.text('1-770-736-8031 x56442'), findsOneWidget);
      expect(find.text('hildegard.org'), findsOneWidget);

      // Verify Address Section
      expect(find.text('Address & Location'), findsOneWidget);
      expect(find.text('Apt. 556, Kulas Light'), findsOneWidget);
      expect(find.text('Gwenborough, 92998-3874'), findsOneWidget);
      expect(find.text('Lat: -37.3159, Lng: 81.1496'), findsOneWidget);

      // Verify Company Section
      expect(find.text('Company Details'), findsOneWidget);
      expect(find.text('Romaguera-Crona'), findsOneWidget);
      expect(find.text('"Multi-layered client-server neural-net"'), findsOneWidget);
      expect(find.text('harness real-time e-markets'), findsOneWidget);
    });

    testWidgets('Navigation from list to detail screen on tap', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode([sampleUserJson]), 200);
      });

      final service = UserService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: UserListScreen(userService: service),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the user card
      await tester.tap(find.text('Leanne Graham'));
      await tester.pumpAndSettle();

      // Verify we have navigated to UserDetailScreen
      expect(find.text('User Details'), findsOneWidget);
      expect(find.text('Company Details'), findsOneWidget);
    });

    testWidgets('MyApp smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Users'), findsOneWidget);
    });
  });
}
