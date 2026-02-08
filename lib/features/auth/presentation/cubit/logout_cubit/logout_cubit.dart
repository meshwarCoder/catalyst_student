import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this.authRepo) : super(LogoutInitial());
  final AuthRepoImplementation authRepo;

  Future<void> logout() async {
    emit(LogoutLoading());
    var result = await authRepo.logout();
    result.fold(
      (failure) => emit(LogoutError(errMessage: failure.errMessage)),
      (success) => emit(LogoutSuccess()),
    );
  }
}
