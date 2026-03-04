---
id: skill_flutter_repository_scaffold
name: Flutter Repository Scaffold
version: 1.0.0
description: Scaffolds Flutter data table repositories extending BaseAsyncDataTableRepository.
tags: [flutter, repository, data, frontend]
permissions: [read_file, write_file, execute_terminal]
---

# Flutter Repository Scaffold

## Overview

Generates Flutter Repository classes designed to drive `data_table_2` asynchronous grids.

These repositories strictly inherit from `BaseAsyncDataTableRepository<T>`, requiring injection of API services and definition of DataRow UI elements directly within the `getRows` override.

## Capabilities

### Scaffold Data Table Repository

**Trigger:** `/datarepo <ModelName>`
**Prerequisites:** The corresponding model must exist in the feature's `data/models` folder.

**Actions:**
1. Generates `lib/features/<feature_name>/data/repositories/<model_name>_repository.dart`.
2. Extends `BaseAsyncDataTableRepository<<ModelName>>`.
3. Connects the API fetcher logic using `apiService`.
4. Stubs out grid UI mapping in `DataRow`.

## Reference Template

```dart
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:medispherexr/core/imports.dart';
import 'package:medispherexr/features/{{feature_name}}/imports.dart';
import 'package:medispherexr/shared/imports.dart';

class {{ModelName}}Repository extends BaseAsyncDataTableRepository<{{ModelName}}> {
  {{ModelName}}Repository({
    required this.apiService,
    required this.onEdit,
    required this.onDelete,
    // Add additional action callbacks if needed
    required super.isMobile,
    required super.titleStyle,
    super.searchQuery,
    super.perPage,
  });

  final {{ModelName}}ApiService apiService;
  final ValueChanged<{{ModelName}}> onEdit;
  final ValueChanged<{{ModelName}}> onDelete;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    try {
      final page = calculatePage(startIndex);

      // Call API
      final paginatedData = await apiService.fetchData(
        SearchRequest(page: page, perPage: perPage, search: searchQuery),
      );

      final pageItems = extractPageItems(
        paginatedData.items,
        startIndex,
        count,
      );

      final rows = pageItems.asMap().entries.map((entry) {
        final index = startIndex + entry.key;
        final item = entry.value;

        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text(item.name ?? '', style: cellStyle)),

            // Add custom cells based on the Model
            /*
            DataCell(
              Text(
                DateHelper.convertDateTimeToString(item.createdAt),
                style: cellStyle,
              ),
            ),
            */

            // Action Buttons
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditButton(
                    onEdit: () => onEdit(item),
                    tooltip: AppStrings.edit, // Make sure string exists in constants
                  ),
                  const SizedBox(width: AppDimens.sm),
                  DeleteButton(
                    onDelete: () => onDelete(item),
                    tooltip: AppStrings.delete, // Make sure string exists in constants
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList();

      return AsyncRowsResponse(paginatedData.pagination.total, rows);
    } catch (e) {
      throw handleError('data fetch', e);
    }
  }
}
```
