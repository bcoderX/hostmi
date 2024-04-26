import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/supabase/rest/houses/views/select_viewed_houses.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/house_card_shimmer.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RecentlyViewsScreen extends StatefulWidget {
  const RecentlyViewsScreen({Key? key}) : super(key: key);

  @override
  State<RecentlyViewsScreen> createState() => _RecentlyViewsScreenState();
}

class _RecentlyViewsScreenState extends State<RecentlyViewsScreen> {
  final PagingController<int, HouseModel> _pagingController =
      PagingController(firstPageKey: 0);

  final int _pageSize = 10;
  @override
  void initState() {
    if (supabase.auth.currentUser != null) {
      _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(
            supabase.auth.currentUser == null
                ? ""
                : supabase.auth.currentUser!.id,
            pageKey);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        title: const Text(
          "Historiques des vues",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        // automaticallyImplyLeading: false,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => Future.sync(() {
              _pagingController.refresh();
            }),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            "Voici les propriétés sur lequelles vous avez cliquées.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PagedSliverList(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<HouseModel>(
                        animateTransitions: true,
                        firstPageErrorIndicatorBuilder: (context) {
                          return Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 50.0, horizontal: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Une erreur s'est produite"),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        _pagingController.refresh();
                                      },
                                      child: const Text("Rééssayer"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ));
                        },
                        newPageErrorIndicatorBuilder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _pagingController.retryLastFailedRequest();
                                },
                                icon: const Icon(
                                  Icons.replay_circle_filled_rounded,
                                  size: 40,
                                  color: AppColor.primary,
                                ),
                              )
                            ],
                          );
                        },
                        firstPageProgressIndicatorBuilder: (context) {
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: List.generate(
                                  2,
                                  (index) => const HouseCardShimmer(),
                                  growable: false,
                                ).animate(
                                  onComplete: (controller) {
                                    controller.repeat();
                                  },
                                ).shimmer(
                                    blendMode: BlendMode.colorDodge,
                                    duration: 1000.ms,
                                    color: Colors.white54),
                              ),
                            )
                          ]);
                        },
                        newPageProgressIndicatorBuilder: (context) {
                          return Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: List.generate(
                                  2,
                                  (index) => const HouseCardShimmer(),
                                  growable: false,
                                ).animate(
                                  onComplete: (controller) {
                                    controller.repeat();
                                  },
                                ).shimmer(
                                    blendMode: BlendMode.colorDodge,
                                    duration: 1000.ms,
                                    color: Colors.white54),
                              ),
                            )
                          ]);
                        },
                        noItemsFoundIndicatorBuilder: (context) {
                          return const Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.hide_image,
                                size: 40,
                                color: AppColor.primary,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Aucun résultat.")
                            ],
                          ));
                        },
                        itemBuilder: (context, item, index) {
                          return HouseCard(
                            house: item,
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchPage(String userId, int pageKey) async {
    //   _resultCount = 0;
    try {
      final response = await selectViewedHouses(
          userId: userId, from: pageKey, to: _pageSize);
      final List<dynamic> list = response!.data;
      list.removeWhere((element) => element["houses"] == null);
      print(list.runtimeType.toString());
      final newItems =
          list.map((e) => HouseModel.fromMap(e["houses"])).toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
}
