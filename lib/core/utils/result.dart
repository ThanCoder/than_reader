sealed class Result<T, E> {
  const Result();

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T unwrap() {
    return switch (this) {
      Ok(value: final val) => val,
      Err() => throw StateError('Called unwrap() on an Err result. '),
    };
  }

  E unwrapError() {
    return switch (this) {
      Err(value: final val) => val,
      Ok() => throw StateError('Called unwrapError() on an Ok result.'),
    };
  }

  R fold<R>({
    required R Function(E err) onErr,
    required R Function(T val) onOk,
  }) => switch (this) {
    Ok(value: final val) => onOk(val),
    Err(value: final val) => onErr(val),
  };
}

class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
}

class Err<T, E> extends Result<T, E> {
  final E value;
  const Err(this.value);
}
