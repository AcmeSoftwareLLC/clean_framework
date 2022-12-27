import 'package:meta/meta.dart';

@Deprecated('Use Either.left')
typedef Left<L, R> = _Left<L, R>;

@Deprecated('Use Either.right')
typedef Right<L, R> = _Right<L, R>;

/// Signature for a function that maps
/// either the left or the right side of this disjunction.
typedef EitherMapper<T, E> = T Function(E);

@sealed
@immutable

/// [Either] represents a value of two possible types.
/// An Either is either an [Either.left] or an [Either.right].
abstract class Either<L, R> {
  /// Constructs an [Either].
  const Either();

  /// The Left version of an [Either].
  const factory Either.left(L value) = _Left<L, R>;

  /// The Right version of an [Either].
  const factory Either.right(R value) = _Right<L, R>;

  /// Returns whether this [Either] is an [Either.left].
  bool get isLeft => this is _Left<L, R>;

  /// Returns whether this [Either] is an [Either.right].
  bool get isRight => this is _Right<L, R>;

  /// Gets the right value if this is an [Either.left]
  /// or throws if this is a [Either.right].
  L get left {
    return fold<L>((left) => left, _noSuchElementException);
  }

  /// Gets the right value if this is an [Either.right]
  /// or throws if this is an [Either.left].
  R get right {
    return fold<R>(_noSuchElementException, (right) => right);
  }

  /// Folds either the left or the right side of this disjunction.
  T fold<T>(EitherMapper<T, L> leftMapper, EitherMapper<T, R> rightMapper);

  Never _noSuchElementException(value) {
    throw NoSuchElementException(
      'You should check ${isLeft ? 'isLeft' : 'isRight'} before calling.',
    );
  }
}

class _Left<L, R> extends Either<L, R> {
  const _Left(this.value);

  /// The Left value of an [Either].
  final L value;

  @override
  T fold<T>(EitherMapper<T, L> leftMapper, EitherMapper<T, R> rightMapper) {
    return leftMapper(value);
  }

  @override
  bool operator ==(Object other) => other is _Left && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class _Right<L, R> extends Either<L, R> {
  const _Right(this.value);

  /// The Right value of an [Either].
  final R value;

  @override
  T fold<T>(EitherMapper<T, L> leftMapper, EitherMapper<T, R> rightMapper) {
    return rightMapper(value);
  }

  @override
  bool operator ==(Object other) => other is _Right && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// [Exception] that indicates the element being requested does not exist.
class NoSuchElementException implements Exception {
  /// Creates a [NoSuchElementException] with an optional error [message].
  const NoSuchElementException([this.message = '']);

  /// The message describing the exception.
  final String message;
}
