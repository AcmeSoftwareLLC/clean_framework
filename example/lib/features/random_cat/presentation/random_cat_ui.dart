import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:example/features/random_cat/domain/random_cat_view_model.dart';
import 'package:example/features/random_cat/presentation/random_cat_presenter.dart';
import 'package:flutter/material.dart';

class RandomCatUI extends UI<RandomCatViewModel> {
  @override
  Presenter create(builder) => RandomCatPresenter(builder: builder);

  @override
  Widget build(BuildContext context, RandomCatViewModel model) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        title: Text('Random Cat'),
      ),
      body: _LazyRandomCatWidget(
        isLoading: model.isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: model.url.isEmpty
                  ? CircularProgressIndicator()
                  : Image.network(model.url),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white10,
                  side: BorderSide(color: Colors.white),
                ),
                onPressed: model.fetch,
                child: Text('Call Another Cat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LazyRandomCatWidget extends StatelessWidget {
  const _LazyRandomCatWidget({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Here, kitty kitty.',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            )
          : child,
    );
  }
}
