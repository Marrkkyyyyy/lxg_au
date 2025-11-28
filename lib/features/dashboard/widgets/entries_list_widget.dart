import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../models/models.dart';

class EntriesListWidget extends StatelessWidget {
  final Entries? entries;
  final bool isLoading;

  const EntriesListWidget({
    super.key, 
    this.entries,
    this.isLoading = false,
  });

  Color _getEntryTypeColor(String source) {
    if (source.toLowerCase().contains('bronze')) {
      return const Color(0xFFCD7F32);
    } else if (source.toLowerCase().contains('silver')) {
      return const Color(0xFFC0C0C0);
    } else if (source.toLowerCase().contains('gold')) {
      return const Color(0xFFFFD700);
    } else if (source.toLowerCase().contains('extra')) {
      return const Color(0xFF007AFF);
    }
    return const Color(0xFFFEC404);
  }

  Widget _buildEntryCard(EntryBatch batch) {
    final entryColor = _getEntryTypeColor(batch.source);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: entryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: entryColor.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batch.source,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.95)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        batch.date,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [entryColor.withOpacity(0.8), entryColor]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: entryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Text(
                    '${batch.count}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFFEC404).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(CupertinoIcons.tickets_fill, color: Color(0xFFFEC404), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Entries',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.95), letterSpacing: -0.5),
                  ),
                  Text(
                    'Total: ${entries?.total ?? 0} entries',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFFFEC404)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isLoading)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFEC404)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loading entries...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            )
          else if (entries == null || entries!.batches.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
              child: Column(
                children: [
                  Icon(CupertinoIcons.ticket, color: Colors.white.withOpacity(0.4), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No entries yet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your entries will appear here',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
            )
          else
            ...entries!.batches.map((batch) => _buildEntryCard(batch)),
        ],
      ),
    );
  }
}
