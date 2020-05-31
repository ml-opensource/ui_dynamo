extension CollectionUtil<T> on Iterable<T>  {

  Iterable<E> mapIndexed<E, T>(E Function(int index, T item) transform) sync* {
    var index = 0;

    for (final item in this) {
      yield transform(index, item as T);
      index++;
    }
  }
}
