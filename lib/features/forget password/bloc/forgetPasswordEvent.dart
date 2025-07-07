import 'package:equatable/equatable.dart';

abstract class Forgetpasswordevent  extends Equatable{
  const Forgetpasswordevent();
  @override
  List<Object?> get props => [];
}

class ForgetpasswordSubmitted extends Forgetpasswordevent{
  final String email;
  const ForgetpasswordSubmitted({required this.email});

  @override
    List<Object?> get props => [email];

}