import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_budget_tracker/app/router/app_routes.dart';
import 'package:smart_budget_tracker/app/shell/app_shell.dart';
import 'package:smart_budget_tracker/features/budget/presentation/screens/budget_screen.dart';
import 'package:smart_budget_tracker/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:smart_budget_tracker/features/receipt_scan/presentation/screens/receipt_capture_screen.dart';
import 'package:smart_budget_tracker/features/receipt_scan/presentation/screens/receipt_review_screen.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:smart_budget_tracker/features/transactions/presentation/screens/transactions_screen.dart';

part 'app_router.g.dart';

/// The application's [GoRouter] configuration.
///
/// The three tabs live inside a [ShellRoute] so the bottom bar survives tab
/// switches, while creation/scanning screens are pushed above the shell.
@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (_, _) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          builder: (_, _) => const TransactionsScreen(),
        ),
        GoRoute(
          path: AppRoutes.budget,
          builder: (_, _) => const BudgetScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.addTransaction,
      builder: (_, _) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: AppRoutes.scan,
      builder: (_, _) => const ReceiptCaptureScreen(),
    ),
    GoRoute(
      path: AppRoutes.receiptReview,
      builder: (context, state) =>
          ReceiptReviewScreen(imagePath: state.extra! as String),
    ),
  ],
);
