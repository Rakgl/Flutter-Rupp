part of 'welcome_cubit.dart';

enum Language { english, french, arabic }

class WelcomeState extends Equatable {
  const WelcomeState({
    this.selectedLanguage,
  });

  final Language? selectedLanguage;

  @override
  List<Object?> get props => [selectedLanguage];

  WelcomeState copyWith({
    Language? selectedLanguage,
  }) {
    return WelcomeState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
