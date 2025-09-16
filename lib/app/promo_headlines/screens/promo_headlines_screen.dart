import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_controller.dart';
import 'package:printeasy_admin/app/promo_headlines/widgets/empty_promo_headline_widget.dart';
import 'package:printeasy_admin/app/promo_headlines/widgets/promo_headline_card_widget.dart';
import 'package:printeasy_admin/util/navigation/app_router.dart';
import 'package:printeasy_admin/util/navigation/pages.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class PromoHeadlinesScreen extends StatelessWidget {
  const PromoHeadlinesScreen({super.key});

  static const String route = AppRoutes.promoHeadlines;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromoHeadlinesController>();
    return GetX<PromoHeadlinesController>(
      initState: (_) {
        final controller = Get.find<PromoHeadlinesController>();
        controller.fetchAllHeadlines();
      },
      builder: (c) => Scaffold(
        floatingActionButton:  FloatingActionButton(
          onPressed: (){
            controller.reset();
            AppRouter.goToAddPromoHeadline();
          },
          child: const Icon(Icons.add),
        ),
        body: controller.isLoading
            ? const Center(child: AppLoader())
            : controller.headlines.isEmpty
                ? const EmptyPromoHeadlineWidget()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                      itemCount: controller.headlines.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final headline = controller.headlines[index];
                        return PromoHeadlineCardWidget(
                          headline: headline,
                          onEdit: (promoHeadlineModel) {
                            AppRouter.goToEditPromoHeadline(promoHeadlineModel);
                          },
                          onDelete: (promoHeadlineModel) {
                            _showDeleteConfirmation(
                                context, promoHeadlineModel);
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, PromoHeadlineModel headline) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Headline?'),
        content:
            Text('Are you sure you want to delete "${headline.headline}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.find<PromoHeadlinesController>().deleteHeadlineById(headline.id!);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
