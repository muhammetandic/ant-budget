# AGENTS.md - Ant Budget (Smart Budget Tracker)

This file defines the core rules, architecture standards, and workflow constraints for all AI agents and developers working in this repository.

---

## 1. Critical Device & Deployment Rules

> [!IMPORTANT]
> **NEVER UNINSTALL THE APPLICATION OR CLEAR APP DATA ON DEVICES.**
> The user actively uses this application on their physical device and has real financial records/data stored locally.
> - **Never** run `adb uninstall com.anttech.antbudget` or `flutter clean` on the device storage.
> - **Never** use `flutter install` — it uninstalls first, wiping all local data.
> - **Always** update in-place using `adb install -r <apk>` (release APK) or `flutter run` (debug).
> - Increment `versionCode` when pushing schema or database changes to allow clean Android package updates.
> - Always maintain backwards-compatible database migrations in `AppDatabase.migration` so existing user data is preserved during upgrades.

---

## 2. Core Architecture & Standards

| Area | Decision | Description |
| :--- | :--- | :--- |
| **Framework** | **Flutter (Dart 3)** | Material 3 design, null-safety, sealed class Result pattern. |
| **State Management** | **Flutter Riverpod** | Code generation via `riverpod_generator` and `riverpod_annotation`. |
| **Persistence** | **Drift (SQLite)** | Tables in `core/data/database/tables/`, DAOs in features. In-place additive migrations only. |
| **Navigation** | **GoRouter** | Centralized routes in `app_routes.dart` and `app_router.dart`. Bottom shell navigation + modal/push routes. |
| **Money Handling** | **Money Value Object** | Amounts stored as integer minor units (`amountMinorUnits`). No binary floating point arithmetic. |
| **Localization** | **l10n (English + Turkish)** | ARB files in `lib/l10n/app_en.arb` and `app_tr.arb`. Always run `flutter gen-l10n`. |
| **Testing** | **Unit & Widget Tests** | Clean mocks/fakes or `NativeDatabase.memory()`. Always shut down timers/streams cleanly. |

---

## 3. Package Structure

```
lib/
├── app/                  # Router, shell, top-level composition
├── core/                 # Shared values (Money, Currency), errors (Result, Failure), database schema
├── features/
│   ├── dashboard/        # Monthly overview card, summary, quick actions
│   ├── transactions/     # Incomes, expenses, transaction history, filters
│   ├── budget/           # Monthly limit, category budgets
│   ├── categories/       # Category management, icons, colours
│   ├── debts/            # Debts and claims tracking (person, amount, date, type, settled)
│   ├── reports/          # Expense breakdown, category & merchant donut charts
│   └── receipt_scan/     # On-device OCR receipt parsing and category suggestion
└── l10n/                 # Localization files
```
