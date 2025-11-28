class EntryBatch {
  final String source;
  final int count;
  final String date;

  EntryBatch({
    required this.source,
    required this.count,
    required this.date,
  });

  factory EntryBatch.fromJson(Map<String, dynamic> json) {
    return EntryBatch(
      source: json['source']?.toString() ?? 'Unknown',
      count: json['count'] ?? 0,
      date: json['date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'count': count,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'EntryBatch(source: $source, count: $count, date: $date)';
  }
}

class Entries {
  final int total;
  final List<EntryBatch> batches;

  Entries({
    required this.total,
    required this.batches,
  });

  factory Entries.fromJson(Map<String, dynamic> json) {
    List<EntryBatch> batches = [];
    
    if (json['batches'] is List) {
      batches = (json['batches'] as List)
          .map((batchJson) => EntryBatch.fromJson(batchJson))
          .toList();
    }

    return Entries(
      total: json['total'] ?? 0,
      batches: batches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'batches': batches.map((batch) => batch.toJson()).toList(),
    };
  }

  static Entries empty() {
    return Entries(total: 0, batches: []);
  }

  @override
  String toString() {
    return 'Entries(total: $total, batches: ${batches.length})';
  }
}