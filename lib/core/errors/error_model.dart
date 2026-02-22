class ErrorModel {
  String? type;
  String? title;
  num? status;
  String? detail;
  String? traceId;

  ErrorModel({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.traceId,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        type: json['type']?.toString(),
        title: json['title']?.toString(),
        status: num.tryParse(json['status'].toString()),
        detail: json['detail']?.toString(),
        traceId: json['traceId']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (type != null) 'type': type,
        if (title != null) 'title': title,
        if (status != null) 'status': status,
        if (detail != null) 'detail': detail,
        if (traceId != null) 'traceId': traceId,
      };

  @override
  String toString() {
    return 'ErrorModel(type: $type, title: $title, status: $status, detail: $detail, traceId: $traceId)';
  }
}
