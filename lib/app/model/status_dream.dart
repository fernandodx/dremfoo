class StatusDream {

  DateTime? date;
  bool? isOk;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['isOk'] = this.isOk;
    return data;
  }

  static StatusDream fromMap(data){
    StatusDream status = StatusDream();
    status.date = data['date'];
    status.isOk = data['isOk'];
    return status;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StatusDream &&
              runtimeType == other.runtimeType &&
              date == other.date;

  @override
  int get hashCode => date.hashCode;





}