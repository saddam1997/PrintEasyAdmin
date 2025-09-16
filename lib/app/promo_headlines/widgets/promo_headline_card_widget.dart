import 'package:flutter/material.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class PromoHeadlineCardWidget extends StatelessWidget {
  const PromoHeadlineCardWidget({
    super.key,
    required this.headline,
    this.onEdit,
    this.onDelete,
  });

  final PromoHeadlineModel headline;
  final Function(PromoHeadlineModel)? onEdit;
  final Function(PromoHeadlineModel)? onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = headline.isActive;
    final isWide = context.isDesktop;
    return TapHandler(
      key: Key('promoHeadline_${headline.id}'),
      onTap: () => onEdit?.call(headline),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: isWide
            ? ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Icon(
                  isActive ? Icons.campaign : Icons.campaign_outlined,
                  color: isActive ? Colors.green : Colors.grey,
                ),
                title: Text(
                  headline.headline,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  'Created on: ${headline.createdAt.toLocal().toString().split(' ').first}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      label: Text(isActive ? 'Active' : 'Inactive'),
                      backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade300,
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => onEdit?.call(headline),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete Reward',
                          onPressed: () => onDelete?.call(headline),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isActive ? Icons.campaign : Icons.campaign_outlined,
                          color: isActive ? Colors.green : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            headline.headline,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Created on: ${headline.createdAt.toLocal().toString().split(' ').first}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Left: Status Chip
                        Chip(
                          label: Text(isActive ? 'Active' : 'Inactive'),
                          backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade300,
                        ),

                        /// Right: Edit + Delete buttons with minimal required space
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          // 🔥 only take required space
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 24,
                              ),
                              tooltip: 'Edit Headline',
                              onPressed: () => onEdit?.call(headline),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 24,
                              ),
                              tooltip: 'Delete Headline',
                              onPressed: () => onDelete?.call(headline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
