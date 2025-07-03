import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_prediction_app/core/helper/spacing.dart';
import 'package:weather_prediction_app/core/strings/strings_manger.dart';
import 'package:weather_prediction_app/core/theming/color_manger.dart';
import 'package:weather_prediction_app/core/theming/text_style_manger.dart';
import 'package:weather_prediction_app/core/widgets/public_button.dart';
import 'package:weather_prediction_app/features/auth/data/model/user_model.dart';
import 'package:weather_prediction_app/features/auth/presentation/cubit_local_data/local_data_cubit.dart';
import 'package:weather_prediction_app/features/home/data/model/weather_model.dart';
import 'package:weather_prediction_app/features/home/presentation/cubit/ai_model_cubit.dart';
import 'package:weather_prediction_app/features/home/presentation/cubit/api_cubit.dart';
import 'package:weather_prediction_app/features/home/presentation/ui/widgets/circle_label.dart';
import 'package:weather_prediction_app/features/home/presentation/ui/widgets/day_container.dart';
import 'package:weather_prediction_app/features/home/presentation/ui/widgets/days_dates.dart';
import 'package:weather_prediction_app/features/home/presentation/ui/widgets/hello_and_name_text.dart';
import 'package:weather_prediction_app/features/home/presentation/ui/widgets/temperature.dart';
import 'package:weather_prediction_app/features/location/bloc/location_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  String? country;
  ForecastModel? forecastModel;
  List<WeatherModel?>? list = [];
  bool isloading = true;
  int index = 0;

  _getdata() async {
    forecastModel = await context.read<ApiCubit>().getWeather();
    user = await context.read<LocalDataCubit>().getCacheUser();
    country = await context.read<LocationBloc>().fetchLocation();
    list = forecastModel?.forecastday;
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: AppColors.blueColor,
        )),
      );
    } else {
      return SafeArea(
        child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: HelloAndNameText(
                        name: user!.name ?? '',
                      )),
                  verticalSpace(30),
                  Center(
                    child: Container(
                      height: 80.h,
                      width: 280.w,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            setState(() {
                              this.index = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: DayContainer(
                              day: DaysDates().days[index],
                              dateDay: DaysDates().dateDays[index],
                            ),
                          ),
                        ),
                        itemCount: 3,
                      ),
                    ),
                  ),
                  verticalSpace(40),
                  Temperature(
                    temp: list![index]!.avgTempC.toString(),
                  ),
                  verticalSpace(60),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleLabel(
                        label: "Humidity",
                        value: list![index]!.avgHumidity.toString(),
                      ),
                      CircleLabel(
                        label: "rain",
                        value: list![index]!.daily_will_it_rain.toString(),
                      ),
                      CircleLabel(
                        label: "UV",
                        value: list![index]!.uv.toString(),
                      ),
                    ],
                  ),
                  verticalSpace(60),
                  PublicButton(
                    title: AppStrings.isTheWeatherIsGood,
                    style: AppStyles.font17WhiteBold,
                    onPressed: () async {
                      if (list![index] != null) {
                        int? i = await context
                            .read<AiModelCubit>()
                            .getPrediction(list![index]);
                        if (i == 1) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              // Todo : replace text content with the home screen
                              content: Text(
                                AppStrings.weatherGood,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else if (i == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              icon: const Icon(
                                Icons.warning_amber_outlined,
                                color: Colors.red,
                              ),
                              content: Text(
                                AppStrings.weatherBad,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
