import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_pill.dart';
import '../models/reservation_request_model.dart';

/// "Pending Requests Requiring Review".
///
/// Renders as a real table on desktop and as stacked cards below the
/// breakpoint — a `DataTable` would force horizontal scrolling on a phone.
class PendingRequestsTable extends StatelessWidget {
  final List<ReservationRequestModel> requests;
  final bool isMobile;
  final bool Function(String id) isBusy;
  final void Function(ReservationRequestModel request) onReview;
  final VoidCallback onViewAll;

  const PendingRequestsTable({
    super.key,
    required this.requests,
    required this.isMobile,
    required this.isBusy,
    required this.onReview,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const Divider(height: 1, color: AppColors.divider),

          if (requests.isEmpty)
            _buildEmptyState()
          else if (isMobile)
            _buildMobileList()
          else
            _buildDesktopTable(),

          const Divider(height: 1, color: AppColors.divider),
          _buildFooter(),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Pending Requests Requiring Review',
              style: AppTextStyles.sectionTitle,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _buildDesktopTable() {
    return Column(
      children: [
        Container(
          color: AppColors.surfaceMuted,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('REQUEST ID', style: AppTextStyles.tableHeader)),
              Expanded(flex: 3, child: Text('REQUESTER / DEPT', style: AppTextStyles.tableHeader)),
              Expanded(flex: 4, child: Text('ORIGIN → DESTINATION', style: AppTextStyles.tableHeader)),
              Expanded(flex: 3, child: Text('DATE & TIME', style: AppTextStyles.tableHeader)),
              Expanded(child: Text('PAX', style: AppTextStyles.tableHeader)),
              Expanded(flex: 2, child: Text('STATUS', style: AppTextStyles.tableHeader)),
              Expanded(flex: 2, child: Text('ACTION', style: AppTextStyles.tableHeader)),
            ],
          ),
        ),
        for (final request in requests) _buildDesktopRow(request),
      ],
    );
  }

  Widget _buildDesktopRow(ReservationRequestModel request) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text('#${request.id}', style: AppTextStyles.mono),
          ),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  request.requesterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyStrong,
                ),
                const SizedBox(height: 2),
                Text(
                  request.department,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          Expanded(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    request.origin,
                    maxLines: 2,
                    style: AppTextStyles.body,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
                Flexible(
                  child: Text(
                    request.destination,
                    maxLines: 2,
                    style: AppTextStyles.body,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDate(request.scheduledAt),
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(request.scheduledAt),
                  style: AppTextStyles.caption.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.neutralSoft,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${request.passengerCount}',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyStrong,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusPill.warning(request.status.label),
            ),
          ),

          Expanded(flex: 2, child: _buildReviewButton(request)),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LIST
  // ============================================================

  Widget _buildMobileList() {
    return Column(
      children: [
        for (final request in requests)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('#${request.id}', style: AppTextStyles.mono),
                    const Spacer(),
                    StatusPill.warning(request.status.label),
                  ],
                ),

                const SizedBox(height: 10),

                Text(request.requesterName, style: AppTextStyles.bodyStrong),
                const SizedBox(height: 2),
                Text(request.department, style: AppTextStyles.caption),

                const SizedBox(height: 10),

                Text(request.route, style: AppTextStyles.body),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${_formatDate(request.scheduledAt)} • '
                      '${_formatTime(request.scheduledAt)}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.people_outline,
                      size: 13,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${request.passengerCount} pax',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: _buildReviewButton(request),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ============================================================
  // SHARED PIECES
  // ============================================================

  Widget _buildReviewButton(ReservationRequestModel request) {
    final bool busy = isBusy(request.id);

    return ElevatedButton(
      onPressed: busy ? null : () => onReview(request),
      child: busy
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Review'),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 44, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 34, color: AppColors.textTertiary),
          SizedBox(height: 12),
          Text('The queue is clear', style: AppTextStyles.bodyStrong),
          SizedBox(height: 4),
          Text(
            'No requests are waiting on a dispatcher right now.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onViewAll,
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward, size: 14),
          label: const Text('View all pending queue'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, '
      '${date.year}';

  String _formatTime(DateTime date) {
    final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}
