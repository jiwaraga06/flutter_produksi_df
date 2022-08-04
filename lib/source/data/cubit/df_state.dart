part of 'df_cubit.dart';

@immutable
abstract class DfState {}

class DfInitial extends DfState {}

class SplashLoading extends DfState {}

class SplashLoaded extends DfState {}

class LoginLoading extends DfState {}

class LoginLoaded extends DfState {}

class LoginMessageSuccess extends DfState {}

class LoginMessageError extends DfState {}

class LoginError extends DfState {}
