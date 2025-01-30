import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/car_body_style/car_body_style_list_screen.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand_list_screen.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/car_model/car_model_list_screen.dart';
import 'package:trokot_dealer_mobile/catalog_settings/catalog_settings.dart';
import 'package:trokot_dealer_mobile/catalog_settings/catalog_settings_notifier.dart';
import 'package:trokot_dealer_mobile/common/ref/model_field.dart';
import 'package:trokot_dealer_mobile/common/ui/text_field.dart';
import 'package:trokot_dealer_mobile/product_category/product_category_screen.dart';
import 'package:trokot_dealer_mobile/setType/set_type_list_screen.dart';

class CatalogSettingsScreen extends StatelessWidget {
  final CatalogSettings catalogSettings;

  const CatalogSettingsScreen({
    super.key,
    required this.catalogSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CatalogSettingsNotifier>(
      create: (context) => CatalogSettingsNotifier(catalogSettings),
      child: Builder(
        builder: (context) {
          final state = context.watch<CatalogSettingsNotifier>();

          return Scaffold(
              appBar: AppBar(
                title: const Text('Настройки каталога'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      final CatalogSettings newSettings = CatalogSettings(
                        name: state.name,
                        sku: state.sku,
                        category: state.category,
                        setType: state.setType,
                        carBrand: state.carBrand,
                        carModel: state.carModel,
                        carBodyStyle: state.carBodyStyle,
                        inStock: state.inStock,
                      );
                      Navigator.pop(context, newSettings);
                    },
                  )
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(5),
                children: [
                  const SizedBox(height: 10),
                  AppTextFieldNull(
                    text: state.name,
                    decoration: const InputDecoration(
                      label: Text('Наименование'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: state.setName,
                  ),
                  const SizedBox(height: 10),
                  AppTextFieldNull(
                    text: state.sku,
                    decoration: const InputDecoration(
                      label: Text('Артикул'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: state.setSku,
                  ),
                  const SizedBox(height: 10),
                  ModelField(
                    value: state.category,
                    openPicker: pickProductCategory,
                    decoration: const InputDecoration(
                      label: Text('Категория'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => state.setCategory(value),
                  ),
                  const SizedBox(height: 10),
                  ModelField(
                    value: state.setType,
                    openPicker: pickSetType,
                    decoration: const InputDecoration(
                      label: Text('Вид комплекта'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => state.setSetType(value),
                  ),
                  const SizedBox(height: 10),
                  ModelField(
                    value: state.carBrand,
                    openPicker: pickCarBrand,
                    decoration: const InputDecoration(
                      label: Text('Марка автомобиля'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => state.setCarBrand(value),
                  ),
                  const SizedBox(height: 10),
                  ModelField(
                    value: state.carModel,
                    openPicker: ({required context, CarModelRef? currentItem}) => pickCarModel(context: context, currentItem: currentItem, carBrand: state.carBrand),
                    decoration: const InputDecoration(
                      label: Text('Модель автомобиля'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => state.setCarModel(value),
                  ),
                  const SizedBox(height: 10),
                  ModelField(
                    value: state.carBodyStyle,
                    openPicker: ({required context, currentItem}) => pickCarBodyStyle(context: context),
                    decoration: const InputDecoration(
                      label: Text('Кузов автомобиля'),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => state.setCarBodyStyle(value),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Только в наличии'),
                      Switch(value: state.inStock, onChanged: state.setInStock),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }
}

Future<CatalogSettings?> showCatalogSettingsScreen(BuildContext context, CatalogSettings catalogSettings) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CatalogSettingsScreen(catalogSettings: catalogSettings),
    ),
  );
}
