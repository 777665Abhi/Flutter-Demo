import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}
class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent({required this.username, required this.password});
  @override
  List<Object?> get props => [username, password];
}
class SignupEvent extends AuthEvent {
  final String username;
  final String password;
  SignupEvent({required this.username, required this.password});
  @override
  List<Object?> get props => [username, password];
}
// States
abstract class AuthState extends Equatable {
  const AuthState();
}
class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}
class AuthSuccess extends AuthState {
  final String username;
  AuthSuccess({required this.username});
  @override
  List<Object?> get props => [username];
}
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}