import 'package:clean_framework/clean_framework_providers.dart';
import 'package:example/features/country/domain/country_view_model.dart';
import 'package:example/features/country/presentation/country_presenter.dart';
import 'package:example/routes.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class CountryUI extends UI<CountryViewModel> {
  @override
  CountryPresenter create(PresenterBuilder<CountryViewModel> builder) {
    return CountryPresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, CountryViewModel model) {
    final headlineStyle = Theme.of(context).textTheme.headline6?.copyWith(
          color: Theme.of(context).scaffoldBackgroundColor,
        );

    final noOfCountries = model.countries.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Countries in '),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              selectedItemBuilder: (context) {
                return [
                  for (final continentName in model.continents.keys)
                    Center(
                      child: Text(continentName, style: headlineStyle),
                    ),
                ];
              },
              iconEnabledColor: Theme.of(context).scaffoldBackgroundColor,
              value: model.selectedContinentId,
              onChanged: (id) => model.fetchCountries(continentId: id),
              items: [
                for (final continent in model.continents.entries)
                  DropdownMenuItem(
                    child: Text(continent.key),
                    value: continent.value,
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _LazyCountryListWidget(
        isLoading: model.isLoading,
        child: RefreshIndicator(
          onRefresh: () => model.fetchCountries(isRefresh: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  '$noOfCountries Countries',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: noOfCountries,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final country = model.countries[index];

                    return ListTile(
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                      leading: Text(
                        country.emoji,
                        style: TextStyle(fontSize: 20),
                      ),
                      title: Text(country.name),
                      subtitle: Text(country.capital),
                      horizontalTitleGap: 0,
                      onTap: () => context.router.go(
                        Routes.countryDetail,
                        params: {'country': country.name},
                        queryParams: {'capital': country.capital},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LazyCountryListWidget extends StatelessWidget {
  const _LazyCountryListWidget({
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
                  Text('Fetching countries ...'),
                ],
              ),
            )
          : child,
    );
  }
}
