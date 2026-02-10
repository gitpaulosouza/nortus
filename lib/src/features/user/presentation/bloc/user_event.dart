abstract class UserEvent {
  const UserEvent();
}

class UserStarted extends UserEvent {
  const UserStarted();
}

class UserRefreshed extends UserEvent {
  const UserRefreshed();
}

class UserNameChanged extends UserEvent {
  final String value;
  const UserNameChanged(this.value);
}

class UserEmailChanged extends UserEvent {
  final String value;
  const UserEmailChanged(this.value);
}

class UserLanguageChanged extends UserEvent {
  final String value;
  const UserLanguageChanged(this.value);
}

class UserDateFormatChanged extends UserEvent {
  final String value;
  const UserDateFormatChanged(this.value);
}

class UserTimezoneChanged extends UserEvent {
  final String value;
  const UserTimezoneChanged(this.value);
}

class UserZipCodeChanged extends UserEvent {
  final String value;
  const UserZipCodeChanged(this.value);
}

class UserCountryChanged extends UserEvent {
  final String value;
  const UserCountryChanged(this.value);
}

class UserStreetChanged extends UserEvent {
  final String value;
  const UserStreetChanged(this.value);
}

class UserNumberChanged extends UserEvent {
  final String value;
  const UserNumberChanged(this.value);
}

class UserComplementChanged extends UserEvent {
  final String value;
  const UserComplementChanged(this.value);
}

class UserNeighborhoodChanged extends UserEvent {
  final String value;
  const UserNeighborhoodChanged(this.value);
}

class UserCityChanged extends UserEvent {
  final String value;
  const UserCityChanged(this.value);
}

class UserStateChanged extends UserEvent {
  final String value;
  const UserStateChanged(this.value);
}

class UserEditCanceled extends UserEvent {
  const UserEditCanceled();
}

class UserSaveRequested extends UserEvent {
  const UserSaveRequested();
}
