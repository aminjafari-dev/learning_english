// usecase.dart
// Base UseCase class for all use cases.

import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
