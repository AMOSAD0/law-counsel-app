import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_prediction_app/core/assets/assets_manger.dart';
import 'package:weather_prediction_app/core/routing/routes.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';
import 'package:weather_prediction_app/features/auth/presentation/cubit_local_data/local_data_cubit.dart';
import 'package:weather_prediction_app/features/location/bloc/location_bloc.dart';


class SplaahScreen extends StatefulWidget {
  const SplaahScreen({super.key});

  @override
  State<SplaahScreen> createState() => _SplaahScreenState();
}

class _SplaahScreenState extends State<SplaahScreen> {
  
  // ignore: unused_field
  Timer? _timer;
  

  _startDelay()async {
    await context.read<LocationBloc>().fetchLocation();
    
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() async{
  UserModel? _user=  await context.read<LocalDataCubit>().getCacheUser();
  if(_user==null){
    Navigator.pushReplacementNamed(context, Routes.loginOrSignup);
  }else{
    Navigator.popAndPushNamed(context, Routes.home);
  }

  }

  @override
  void initState() {
    super.initState();
    
    _startDelay();

    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppAssets.logo, width: 200.0.w, height: 200.0.h,),
      ),
    );
  }
}