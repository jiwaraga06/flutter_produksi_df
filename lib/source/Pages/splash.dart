import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_produksi/source/data/cubit/df_cubit.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DfCubit>(context).splashAuth(context);
    return Scaffold(
      body: BlocListener<DfCubit, DfState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
