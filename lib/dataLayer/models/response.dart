class Response<T> {
  ResponseStatus status;
  T results;

  Response(this.status, {this.results});

}

enum ResponseStatus {
  loading,
  success,
  error
}