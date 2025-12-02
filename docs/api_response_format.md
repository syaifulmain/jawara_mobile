# API Response Format for Income Categories

## Expected Response Format

Untuk endpoint income categories, backend sebaiknya mengirim response dengan format berikut:

### Option 1: Include User Relationship (Recommended)
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Iuran Bulanan RT 03",
      "type": "bulanan",
      "nominal": "25000.00",
      "description": "Iuran rutin bulanan untuk kegiatan RT 03",
      "created_by": {
        "id": 1,
        "name": "Admin Kawasan"
      },
      "created_at": "2025-12-01T03:42:21",
      "updated_at": "2025-12-01T03:42:21"
    }
  ]
}
```

### Option 2: Separate Fields (Alternative)
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Iuran Bulanan RT 03",
      "type": "bulanan",
      "nominal": "25000.00",
      "description": "Iuran rutin bulanan untuk kegiatan RT 03",
      "created_by": 1,
      "created_by_name": "Admin Kawasan",
      "created_at": "2025-12-01T03:42:21",
      "updated_at": "2025-12-01T03:42:21"
    }
  ]
}
```

## Model Handling

Model `IncomeCategories` sudah di-update untuk handle kedua format di atas:

- `createdBy` (int) - Foreign key ke tabel users
- `createdByName` (String?) - Nama user untuk display
- `createdByDisplayName` (getter) - Helper method untuk display

## Backend Implementation Suggestion

Dalam Laravel/PHP backend, bisa menggunakan:

```php
// Option 1: Using Eloquent relationship
return IncomeCategory::with('creator:id,name')->get();

// Option 2: Using join
return IncomeCategory::join('users', 'income_categories.created_by', '=', 'users.id')
    ->select('income_categories.*', 'users.name as created_by_name')
    ->get();
```

## Benefits

1. **Type Safety**: createdBy sebagai int foreign key sesuai database schema
2. **Display Flexibility**: createdByName untuk tampilan user-friendly
3. **Backward Compatibility**: Model bisa handle response tanpa user name
4. **Performance**: Bisa memilih kapan perlu include user information