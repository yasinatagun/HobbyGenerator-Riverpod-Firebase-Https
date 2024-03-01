import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_generator/models/hobby.dart';
import 'package:hobby_generator/services/hobby_service.dart';

class HobbyNotifier extends StateNotifier<HobbyState> {
  final HobbyService _hobbyService;

  HobbyNotifier(this._hobbyService) : super(HobbyState());

  Future<void> fetchHobby(String category) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      Hobby hobby = await _hobbyService.fetchHobby(category);
      state = state.copyWith(isLoading: false, hobby: hobby);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load hobby');
    }
  }

  void clearHobby() {
    state = HobbyState();
  }
  
}
final hobbyNotifierProvider = StateNotifierProvider<HobbyNotifier, HobbyState>((ref) {
  return HobbyNotifier(HobbyService());
});

class HobbyState {
  final bool isLoading;
  final Hobby? hobby;
  final String? errorMessage;

  HobbyState({this.isLoading = false, this.hobby, this.errorMessage});

  HobbyState copyWith({bool? isLoading, Hobby? hobby, String? errorMessage}) {
    return HobbyState(
      isLoading: isLoading ?? this.isLoading,
      hobby: hobby ?? this.hobby,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}