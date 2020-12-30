class Entry {
  double _hours;

  Entry(this._hours);

  Entry.fromJson(Map<String, dynamic> map) {
    this._hours = map['hours'];
  }

  double get hours => _hours;
}