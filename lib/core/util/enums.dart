enum FilterState {
  open,
  closed,
  all,
}

enum SortOption {
  created,
  updated,
  comment,
}

extension ParseToStringFilter on FilterState {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

extension ParseToStringSort on SortOption {
  String toShortString() {
    return this.toString().split('.').last;
  }
}