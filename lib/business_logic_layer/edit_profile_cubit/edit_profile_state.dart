
 class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}
final class EditProfileLoading extends EditProfileState {}
final class EditProfileSuccess extends EditProfileState {}
final class EditProfileError extends EditProfileState {
 final String error;

  EditProfileError(this.error);
}
