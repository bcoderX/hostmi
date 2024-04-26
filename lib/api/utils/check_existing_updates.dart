import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/constants/version.dart';
import 'package:hostmi/api/models/hostmi_update_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/updates/check_for_app_updates.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:provider/provider.dart';

void checkExistingUpdates(BuildContext context) {
  if (!context.read<HostmiProvider>().hasCheckedUpdates) {
    checkInternetStatus().then((value) {
      if (value) {
        checkForUpdates().then((response) {
          if (response.isSuccess) {
            if (response.list!.isNotEmpty) {
              HostmiUpdate update =
                  HostmiUpdate.fromMap(data: response.list![0]);

              bool hasUpdate =
                  isCurrentVersionSmaller(update.version!, version);
              context.read<HostmiProvider>().setHasCheckedUpdates(true);
              context.read<HostmiProvider>().setUpdate(update);
              context.read<HostmiProvider>().setHasUpdates(hasUpdate);
              debugPrint(update.isRequired!.toString());
              if (update.isRequired! && hasUpdate) {
                context.go('/required-update');
              }
            }
          }
        });
      }
    });
  }
}
