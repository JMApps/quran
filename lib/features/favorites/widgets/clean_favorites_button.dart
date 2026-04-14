import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/presentation/state/favorites_state.dart';

class CleanFavoritesButton extends StatelessWidget {
  const CleanFavoritesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Padding(
              padding: AppStyles.withoutTopPadding,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Provider.of<FavoritesState>(context, listen: false).clearAllFavorites();
                                },
                                child: const Text(
                                  AppStrings.delete,
                                  style: AppStyles.mainTextStyle18,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  AppStrings.cancel,
                                  style: AppStyles.mainTextStyle18,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      AppStrings.deleteAllFavorites,
                      style: AppStyles.mainTextStyle18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      AppStrings.cancel,
                      style: AppStyles.mainTextStyle18,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.delete_rounded),
    );
  }
}
