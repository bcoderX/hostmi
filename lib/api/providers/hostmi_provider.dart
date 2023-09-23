import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hostmi/api/schemas/authentication_schema.dart';
import 'package:hostmi/api/schemas/page_schema.dart';
import 'package:hostmi/api/utils/end_point.dart';

class HostmiProvider with ChangeNotifier {
  bool _isLoading = false;
  String _response = '';
  dynamic _list = [];
  dynamic _otpSent = false;
  bool get getLoadingStatus => _isLoading;
  String get getResponse => _response;
  final EndPoint _point = EndPoint();

  //Page variables
  bool _isCreatingPage = false;
  bool _isCreated = false;

  void queryFunc(bool isLocal) async {
    ValueNotifier<GraphQLClient> client = _point.getClient();

    QueryResult result = await client.value.query(
      QueryOptions(
        document: gql(AuthenticationSchema.sendOTP),
        fetchPolicy: isLocal == true ? null : FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      // check if we have any exception
      _isLoading = false;
      if (result.exception!.graphqlErrors.isEmpty) {
        _response = "Internet is not found";
      } else {
        _response = result.exception!.graphqlErrors[0].message.toString();
      }
      notifyListeners();
    } else {
      // no exception, set the todos (list)
      _isLoading = false;
      _list = result.data;
      notifyListeners();
    }
  }

  void sendOTP({String? phoneNumber}) async {
    _isLoading = true;
    _response = "Please wait...";
    notifyListeners();

    ValueNotifier<GraphQLClient> client = _point.getClient();

    QueryResult result = await client.value.mutate(MutationOptions(
        document: gql(AuthenticationSchema.sendOTP),
        variables: {
          'phoneNumber': phoneNumber,
        }));

    if (result.hasException) {
      // Check if there is any exception raised.
      _isLoading = false;
      if (result.exception!.graphqlErrors.isEmpty) {
        _response = "Internet is not found";
      } else {
        _response = result.exception!.graphqlErrors[0].message.toString();
      }
      notifyListeners();
    } else {
      _list = result.data;
      Map<String, Map<String, dynamic>>? data =
          result.data?.cast<String, Map<String, dynamic>>();
      if (data!["sendOtp"]!["success"] == true) {
        debugPrint("Otp sent");
        _otpSent = true;
      }
      _isLoading = false;
      _response = "Todo was successfully added";
      notifyListeners();
    }
    debugPrint(result.data.toString());
    debugPrint(_response);
  }

  void createPage({
    required String user,
    required String name,
    required String phoneNumber,
    required String email,
    required String cities,
    required String references,
    required String description,
    required String address,
  }) async {
    _isCreatingPage = true;
    _response = "Please wait...";
    notifyListeners();

    ValueNotifier<GraphQLClient> client = _point.getClient();

    QueryResult result = await client.value.mutate(
      MutationOptions(
        document: gql(PageSchema.createPage),
        variables: {
          'user': user,
          'name': name,
          'phoneNumber': phoneNumber,
          'email': email,
          'cities': cities,
          'references': references,
          'description': description,
          'address': address,
        },
      ),
    );

    if (result.hasException) {
      // Check if there is any exception raised.
      _isCreatingPage = false;
      if (result.exception!.graphqlErrors.isEmpty) {
        _response = "Internet is not found";
      } else {
        _response = result.exception!.graphqlErrors[0].message.toString();
      }
      notifyListeners();
    } else {
      _list = result.data;
      Map<String, Map<String, dynamic>>? data =
          result.data?.cast<String, Map<String, dynamic>>();
      if (data!["createPage"]!["success"] == true) {
        debugPrint("Page sent");
        _isCreated = true;
      }
      _isCreatingPage = false;
      _response = "Todo was successfully added";
      notifyListeners();
    }
    debugPrint(result.data.toString());
    debugPrint(_response);
  }

  void clearResponse() {
    _response = '';
    notifyListeners();
  }
}
