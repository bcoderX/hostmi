import 'package:flutter/material.dart';
import 'package:hostmi/api/constants/version.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/database_update_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/updates/check_for_database_updates.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:provider/provider.dart';

void checkExistingDbUpdates(BuildContext context) {
  if (!context.read<HostmiProvider>().hasCheckedDbUpdates) {
    checkInternetStatus().then((value) {
      if (value) {
        checkForDbUpdates().then((response) {
          if (response.isSuccess) {
            if (response.list!.isNotEmpty) {
              DatabaseUpdateModel update =
                  DatabaseUpdateModel.fromMap(data: response.list![0]);
              bool hasUpdate = isCurrentVersionSmaller(
                  update.version!, getCurrentDbVersion());
              if (hasUpdate) {
                context
                    .read<HostmiProvider>()
                    .getCountries(forceUpdate: true, version: update.version);
                context
                    .read<HostmiProvider>()
                    .getHouseTypes(forceUpdate: true, version: update.version);
                context.read<HostmiProvider>().getHouseCategories(
                    forceUpdate: true, version: update.version);
                context
                    .read<HostmiProvider>()
                    .getPriceTypes(forceUpdate: true, version: update.version);
                context.read<HostmiProvider>().getHouseFeatures(
                    forceUpdate: true, version: update.version);
                context
                    .read<HostmiProvider>()
                    .getGenders(forceUpdate: true, version: update.version);
                context
                    .read<HostmiProvider>()
                    .getJobs(forceUpdate: true, version: update.version);
                context.read<HostmiProvider>().getMaritalStatus(
                    forceUpdate: true, version: update.version);
                context
                    .read<HostmiProvider>()
                    .getCurrencies(forceUpdate: true, version: update.version);
              }
              context.read<HostmiProvider>().setHasCheckedDbUpdates(true);
            }
          }
        });
      }
    });
  }
}
