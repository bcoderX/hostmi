import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<int> selectViewsCount( String houseId) async {
  try {
    final count = await supabase
        .from("houses_views")
        .select("*", const FetchOptions(head: true, count: CountOption.exact))
        .eq("house_id", houseId);
    debugPrint(count);
    return count;
  } catch (e) {
    debugPrint(e.toString());
    return 0;
  }
}
