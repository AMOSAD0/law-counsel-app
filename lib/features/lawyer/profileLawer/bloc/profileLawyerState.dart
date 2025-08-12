
import 'package:equatable/equatable.dart';
class LawyerProfileState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? lawyerData;
  final String? error;
  final bool isSuccess;
  final double? netPrice;
  final double? balance;  

  const LawyerProfileState({
    this.isLoading = false,
    this.lawyerData,
    this.error,
    this.isSuccess = false,
    this.netPrice,
    this.balance,
  });

  LawyerProfileState copyWith({
    bool? isLoading,
    Map<String, dynamic>? lawyerData,
    String? error,
    bool? isSuccess,
    double? netPrice,
    double? balance,
  }) {
    return LawyerProfileState(
      isLoading: isLoading ?? this.isLoading,
      lawyerData: lawyerData ?? this.lawyerData,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      netPrice: netPrice ?? this.netPrice,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [isLoading, lawyerData, error, isSuccess, netPrice, balance];
}
