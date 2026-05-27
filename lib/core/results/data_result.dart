class DataResult<T> {
  final T? data;
  final bool isCacheData;
  final String? error;

  DataResult({required this.data, this.isCacheData = false, this.error});

  bool get isSuccess => data != null && error == null;

  bool get isError => error != null && data == null;
}
