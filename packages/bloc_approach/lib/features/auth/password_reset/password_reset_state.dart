abstract class PasswordResetState {}

class EmailInputForm extends PasswordResetState {}

class AuthError extends PasswordResetState {}

class Loading extends PasswordResetState {}

class ResetInstructionsDelivered extends PasswordResetState {}
