import 'package:equatable/equatable.dart';

enum Forgetpasswordstatus {initial, loading, success, failure}

class Forgetpasswordstate extends Equatable{
  final Forgetpasswordstatus status;
  final String ? error;

  const Forgetpasswordstate({
    this.status=Forgetpasswordstatus.initial,
    this.error
  });


  Forgetpasswordstate copyWith({
    Forgetpasswordstatus ? status,
    String ? error,
  }){
    return Forgetpasswordstate(
      status: status ?? this.status,
      error: error,
    );
  }



  @override
  List<Object?> get props => [status,error??''];
  }