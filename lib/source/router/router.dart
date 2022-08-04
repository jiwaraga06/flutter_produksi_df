import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_produksi/source/Pages/Dashboard/index.dart';
import 'package:flutter_produksi/source/Pages/Home/index.dart';
import 'package:flutter_produksi/source/Pages/InputHasilDF/index.dart';
import 'package:flutter_produksi/source/Pages/List_JO/index.dart';
import 'package:flutter_produksi/source/Pages/Login/index.dart';
import 'package:flutter_produksi/source/Pages/splash.dart';
import 'package:flutter_produksi/source/data/cubit/df_cubit.dart';
import 'package:flutter_produksi/source/data/network/network.dart';
import 'package:flutter_produksi/source/data/repository/repository.dart';
import 'package:flutter_produksi/source/router/string.dart';

class RouterNavigation {
  MyRepository? myRepository;

  RouterNavigation() {
    myRepository = MyRepository(myNetwork: MyNetwork());
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => DfCubit(myRepository: myRepository),
            child: SplashScreen(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case LOGIN:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => DfCubit(
                      myRepository: myRepository,
                    ),
                child: Login()));
      case DASHBOARD:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => DfCubit(myRepository: myRepository),
            child: Dashboard(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case HOME:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => DfCubit(myRepository: myRepository),
            child: Home(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case INPUT_HASIL_DF:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => DfCubit(myRepository: myRepository),
            child: InputHasilDF(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case LIST_JO:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => DfCubit(myRepository: myRepository),
            child: ListJO(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      default:
        return null;
    }
  }
}
