import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/auth_state_notifier.dart';
import '../../features/accounts/presentation/screens/account_detail_screen.dart';
import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/bills/presentation/screens/bills_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/debt/presentation/screens/debt_screen.dart';
import '../../features/financial_health/presentation/screens/financial_health_screen.dart';
import '../../features/forecast/presentation/screens/forecast_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/investments/presentation/screens/investments_screen.dart';
import '../../features/more/presentation/screens/more_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/billing_history_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/password_security_screen.dart';
import '../../features/profile/presentation/screens/payment_methods_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/savings/presentation/screens/savings_screen.dart';
import '../../features/settings/presentation/screens/about_app_screen.dart';
import '../../features/settings/presentation/screens/active_sessions_screen.dart';
import '../../features/settings/presentation/screens/legal_document_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/transactions/presentation/screens/transaction_detail_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/settings/presentation/widgets/legal_content.dart';

/// Route path constants -- the single source of truth for every location
/// in the app. Screens navigate with `context.go`/`context.push` using
/// these constants instead of hard-coded strings.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String register = '/login/register';
  static const String forgotPassword = '/login/forgot-password';
  static const String verifyOtp = '/login/forgot-password/verify-otp';
  static const String resetPassword = '/login/reset-password';

  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String accounts = '/accounts';
  static const String aiChat = '/ai-chat';
  static const String more = '/more';

  static const String budget = '/budget';
  static const String savings = '/savings';
  static const String bills = '/bills';
  static const String analytics = '/analytics';
  static const String forecast = '/forecast';
  static const String financialHealth = '/financial-health';
  static const String alerts = '/alerts';
  static const String debt = '/debt';
  static const String investments = '/investments';

  static const String settings = '/settings';
  static const String settingsSessions = '/settings/sessions';
  static const String settingsAbout = '/settings/about';
  static const String settingsTerms = '/settings/legal/terms';
  static const String settingsPrivacy = '/settings/legal/privacy';

  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profilePasswordSecurity = '/profile/password-security';
  static const String profilePaymentMethods = '/profile/payment-methods';
  static const String profileBillingHistory = '/profile/billing-history';

  static const String subscription = '/subscription';
  static const String help = '/help';

  static String transactionDetail(String id) => '/transactions/$id';

  static const Set<String> _publicPrefixes = {onboarding, login, splash};

  static bool isPublic(String location) =>
      _publicPrefixes.any((p) => location == p || location.startsWith('$p/'));
}

/// Centralized GoRouter configuration -- the app's only intentional
/// architectural addition on top of the existing NexaR AI-derived scaffold.
/// Every other screen keeps its existing widget tree; only *how you get
/// there* changed from `Navigator.push(MaterialPageRoute(...))` to named
/// routes.
class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: isLoggedInNotifier,
    redirect: (context, state) {
      final bool loggedIn = isLoggedInNotifier.value;
      final String location = state.matchedLocation;
      final bool isPublic = AppRoutes.isPublic(location);

      if (!loggedIn && !isPublic) return AppRoutes.login;
      if (loggedIn && isPublic && location != AppRoutes.splash) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(
          onFinished: () => context.go(AppRoutes.onboarding),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
            routes: [
              GoRoute(
                path: 'verify-otp',
                builder: (context, state) =>
                    VerifyOtpScreen(email: state.extra as String? ?? ''),
              ),
            ],
          ),
          GoRoute(
            path: 'reset-password',
            builder: (context, state) => const ResetPasswordScreen(),
          ),
        ],
      ),

      // ── Protected bottom-nav shell ──────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.transactions,
              builder: (context, state) => const TransactionsScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddTransactionScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => TransactionDetailScreen(
                    transactionId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.accounts,
              builder: (context, state) => const AccountsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => AccountDetailScreen(
                    accountId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.aiChat,
              builder: (context, state) => const ChatScreen(showBackButton: false),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.more,
              builder: (context, state) => const MoreScreen(),
            ),
          ]),
        ],
      ),

      // ── Protected, pushed from Dashboard/More ───────────────────────
      GoRoute(
        path: AppRoutes.budget,
        builder: (context, state) => const BudgetScreen(),
      ),
      GoRoute(
        path: AppRoutes.savings,
        builder: (context, state) => const SavingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.bills,
        builder: (context, state) => const BillsScreen(),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.forecast,
        builder: (context, state) => const ForecastScreen(),
      ),
      GoRoute(
        path: AppRoutes.financialHealth,
        builder: (context, state) => const FinancialHealthScreen(),
      ),
      GoRoute(
        path: AppRoutes.alerts,
        builder: (context, state) => const AlertsScreen(),
      ),
      GoRoute(
        path: AppRoutes.debt,
        builder: (context, state) => const DebtScreen(),
      ),
      GoRoute(
        path: AppRoutes.investments,
        builder: (context, state) => const InvestmentsScreen(),
      ),

      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'sessions',
            builder: (context, state) => const ActiveSessionsScreen(),
          ),
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutAppScreen(),
          ),
          GoRoute(
            path: 'legal/terms',
            builder: (context, state) => const LegalDocumentScreen(
              title: AppStrings.termsOfServiceLabel,
              sections: termsOfServiceSections,
            ),
          ),
          GoRoute(
            path: 'legal/privacy',
            builder: (context, state) => const LegalDocumentScreen(
              title: AppStrings.privacyPolicyLabel,
              sections: privacyPolicySections,
            ),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: 'password-security',
            builder: (context, state) => const PasswordSecurityScreen(),
          ),
          GoRoute(
            path: 'payment-methods',
            builder: (context, state) => const PaymentMethodsScreen(),
          ),
          GoRoute(
            path: 'billing-history',
            builder: (context, state) => const BillingHistoryScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) => const HelpScreen(),
      ),
    ],
  );
}
