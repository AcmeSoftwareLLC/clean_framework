import 'package:clean_framework/clean_framework_core.dart';

class HomeViewModel extends ViewModel {
  HomeViewModel({required this.pokemons});

  final List<String> pokemons;

  @override
  List<Object?> get props => [pokemons];
}
