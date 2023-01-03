import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeUI extends UI<HomeViewModel> {
  @override
  HomePresenter create(PresenterBuilder<HomeViewModel> builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Text(viewModel.pokemons[index]),
        itemCount: viewModel.pokemons.length,
      ),
    );
  }
}
