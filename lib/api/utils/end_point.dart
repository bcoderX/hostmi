import 'package:flutter/foundation.dart';
import 'package:hostmi/api/utils/url.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EndPoint {
  ValueNotifier<GraphQLClient> getClient() {
    ValueNotifier<GraphQLClient> _client = ValueNotifier(GraphQLClient(
      link: HttpLink(endPointUrl, defaultHeaders: {
      }),
      cache: GraphQLCache(store: HiveStore()),
    ));

    return _client;
  }
}