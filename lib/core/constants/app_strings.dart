/// Centralized text constants for the NexaAi template.
///
/// Every user-facing string used across features is defined here instead
/// of being hardcoded inline in widgets/screens -- this keeps copy easy
/// to find, reuse and change from one place. Strings that need runtime
/// values (an email, a countdown) are exposed as small static methods so
/// the template text still lives here rather than being rebuilt inline.
class AppStrings {
  const AppStrings._();

  // ---------------------------------------------------------------------
  // Branding
  // ---------------------------------------------------------------------
  static const String appName = 'RimRid Finance';
  static const String appTagline = 'Your AI Finance Companion';

  // ---------------------------------------------------------------------
  // Common actions
  // ---------------------------------------------------------------------
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String retry = 'Retry';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String done = 'Done';
  static const String skip = 'Skip';
  static const String continueLabel = 'Continue';
  static const String submit = 'Submit';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
  static const String search = 'Search';
  static const String seeAll = 'See All';
  static const String loading = 'Loading...';

  // ---------------------------------------------------------------------
  // Generic messages
  // ---------------------------------------------------------------------
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String noInternetMessage =
      'No internet connection. Please check your network.';
  static const String sessionExpiredMessage =
      'Your session has expired. Please sign in again.';
  static const String noDataFoundMessage = 'No data found.';
  static const String noResultsFoundMessage = 'No results found.';

  // ---------------------------------------------------------------------
  // Generic validation messages
  // ---------------------------------------------------------------------
  static const String fieldRequiredMessage = 'This field is required.';
  static const String invalidEmailMessage = 'Enter a valid email address.';
  static const String passwordTooShortMessage =
      'Password must be at least 8 characters.';
  static const String passwordsDoNotMatchMessage = 'Passwords do not match.';

  // ---------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------
  static const String onboardingGetStarted = 'Get Started';
  static const String onboardingTag1 = 'AI FINANCE ASSISTANT';
  static const String onboardingTag2 = 'ALL YOUR FINANCES, ONE APP';
  static const String onboardingTag3 = 'SMARTER MONEY DECISIONS';

  static const String onboardingTitle1 = 'Ask Your Money Anything';
  static const String onboardingDescription1 =
      'Get instant, intelligent answers about your spending, budgets, and '
      'goals -- anytime, anywhere.';

  static const String onboardingTitle2 = 'Everything In One Place';
  static const String onboardingDescription2 =
      'Track transactions, manage budgets, and hit your savings goals -- '
      'all in one clean dashboard.';

  static const String onboardingTitle3 = 'Your Goals, Within Reach';
  static const String onboardingDescription3 =
      'Turn spending insights into real progress with RimRid Finance.';

  static const String onboardingChatAssistantHeader = 'AI Finance Assistant';
  static const String onboardingGptModel = 'Live';
  static const String onboardingSampleUserPrompt =
      'Where did I overspend this month?';
  static const String onboardingSampleAiResponse =
      "You're \$42 over your Dining budget...";
  static const String onboardingToolWriter = 'Budgets';
  static const String onboardingToolCode = 'Transactions';
  static const String onboardingToolImage = 'Savings Goals';
  static const String onboardingToolVoice = 'Bill Reminders';
  static const String onboardingBadgePro = 'Smart';
  static const String onboardingBadgeFast = 'Auto';
  static const String onboardingBadgeHd = 'Goal';
  static const String onboardingBadgeLive = 'Alert';
  static const String onboardingMetricSpeedup = '3.2x Savings';
  static const String onboardingMetricSubtitle =
      'Smarter budgeting with AI insights';
  static const String onboardingMetricExecutionSpeed = 'Budget Accuracy';
  static const String onboardingMetricAvgResponse = '98% On Target';
  static const String onboardingMetricUnlimitedTokens = 'Real-time Sync';
  static const String onboardingMetricSecure = '256-bit Secure';

  // ---------------------------------------------------------------------
  // Shared auth form fields
  // ---------------------------------------------------------------------
  static const String emailLabel = 'Email';
  static const String emailHint = 'you@example.com';
  static const String passwordLabel = 'Password';

  // ---------------------------------------------------------------------
  // Shared social sign-in
  // ---------------------------------------------------------------------
  static const String orDivider = 'OR';
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueWithApple = 'Continue with Apple';
  static const String continueWithFacebook = 'Continue with Facebook';
  static const String googleSignInComingSoon = 'Google sign-in coming soon.';
  static const String appleSignInComingSoon = 'Apple sign-in coming soon.';
  static const String facebookSignInComingSoon =
      'Facebook sign-in coming soon.';

  // ---------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Log in to continue to RimRid Finance.';
  static const String passwordHintLogin = 'Enter your password';
  static const String forgotPasswordLabel = 'Forgot Password?';
  static const String loginButtonLabel = 'Log In';
  static const String loginSuccessMessage = 'Signed in successfully (demo).';
  static const String noAccountPrompt = "Don't have an account?";
  static const String signUpLabel = 'Sign Up';

  // ---------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle =
      'Sign up to get started with NexaAi.';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'Ada Lovelace';
  static const String passwordHintRegister = 'Create a password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String registerSuccessMessage =
      'Account created successfully (demo).';
  static const String registerButtonLabel = 'Create Account';
  static const String haveAccountPrompt = 'Already have an account?';
  static const String alreadyHaveAccountPrompt = 'Already have an account?';
  static const String signInLabel = 'Log In';

  // ---------------------------------------------------------------------
  // Forgot password
  // ---------------------------------------------------------------------
  static const String forgotPasswordTitle = 'Forgot Password?';
  static const String forgotPasswordSubtitle =
      "Enter your email and we'll send you a code to reset your password.";
  static const String sendCodeButtonLabel = 'Send Code';

  // ---------------------------------------------------------------------
  // Verify OTP
  // ---------------------------------------------------------------------
  static const String verifyCodeTitle = 'Verify Code';
  static const String noCodePrompt = "Didn't receive the code?";
  static const String resendLabel = 'Resend';
  static const String verifyButtonLabel = 'Verify';

  static String otpSentTo(int length, String email) =>
      'Enter the $length-digit code sent to $email.';
  static String resendInSeconds(int seconds) => 'Resend in ${seconds}s';
  static String otpResentTo(String email) => 'A new code was sent to $email.';

  // ---------------------------------------------------------------------
  // Reset password
  // ---------------------------------------------------------------------
  static const String resetPasswordTitle = 'Reset Password';
  static const String resetPasswordSubtitle =
      'Your new password must be different from previously used passwords.';
  static const String newPasswordLabel = 'New Password';
  static const String newPasswordHint = 'Enter your new password';
  static const String confirmNewPasswordLabel = 'Confirm New Password';
  static const String confirmNewPasswordHint = 'Re-enter your new password';
  static const String resetPasswordSuccessMessage =
      'Password reset successfully. Please log in.';

  // ---------------------------------------------------------------------
  // Greeting (time-of-day)
  // ---------------------------------------------------------------------
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';

  // ---------------------------------------------------------------------
  // Relative time (used by DateTimeX.timeAgo)
  // ---------------------------------------------------------------------
  static const String justNow = 'just now';
  static String minutesAgo(int minutes) => '${minutes}m ago';
  static String hoursAgo(int hours) => '${hours}h ago';
  static String daysAgo(int days) => '${days}d ago';

  // ---------------------------------------------------------------------
  // Demo/mock user (UI-only template -- no real auth session yet)
  // ---------------------------------------------------------------------
  static const String demoUserName = 'Alex Morgan';
  static const String demoUserEmail = 'alex.morgan@example.com';
  static const String demoUserPlan = 'Free Plan';

  // ---------------------------------------------------------------------
  // Home / Dashboard
  // ---------------------------------------------------------------------
  static const String homeSearchHint = 'Ask AI anything...';
  static const String aiToolsSectionTitle = 'AI Tools';
  static const String quickAccessTitle = 'Quick Access';
  static const String pinnedChatsTitle = 'Pinned Chats';
  static const String recentChatsSectionTitle = 'Recent Chats';
  static const String chatHistoryScreenTitle = 'Chat History';
  static const String noChatHistoryTitle = 'No conversations yet';
  static const String noChatHistoryMessage =
      'Start a new chat and it will show up here.';
  static const String toolComingSoonMessage = 'This tool is coming soon.';
  static const String moreTools = 'More';

  static const String upgradeToProTitle = 'Upgrade to Pro';
  static const String upgradeToProSubtitle =
      'Unlock more AI power and unlimited access.';

  static const String toolChat = 'AI Chat';
  static const String toolWriter = 'AI Writer';
  static const String toolImageGenerator = 'Image Generator';
  static const String toolSummarizer = 'Summarizer';
  static const String toolTranslator = 'Translator';
  static const String toolCodeAssistant = 'Code Assistant';

  // Writing & Content
  static const String toolGrammarChecker = 'Grammar Checker';
  static const String toolParaphraser = 'Paraphraser';
  static const String toolSeoGenerator = 'SEO Generator';
  static const String toolEmailGenerator = 'Email Generator';

  // Audio & Video
  static const String toolVoiceGenerator = 'Voice Generator';
  static const String toolTranscription = 'Transcription';
  static const String toolVideoScript = 'Video Script Writer';

  // Productivity
  static const String toolPdfAssistant = 'PDF Assistant';
  static const String toolPresentationMaker = 'Presentation Maker';
  static const String toolResumeBuilder = 'Resume Builder';
  static const String toolDataAnalyzer = 'Data Analyzer';

  // Design & Dev
  static const String toolLogoGenerator = 'Logo Generator';
  static const String toolBackgroundRemover = 'Background Remover';
  static const String toolSqlGenerator = 'SQL Generator';
  static const String toolRegexGenerator = 'Regex Generator';

  // ---------------------------------------------------------------------
  // AI Tools screen
  // ---------------------------------------------------------------------
  static const String aiToolsScreenTitle = 'AI Tools';
  static const String aiToolsScreenSubtitle =
      'Explore everything NexaAi can do for you.';
  static const String comingSoonBadge = 'Soon';
  static const String newBadge = 'NEW';
  static const String proBadge = 'PRO';

  // Filter tabs
  static const String filterAll = 'All';
  static const String filterWriting = 'Writing';
  static const String filterImage = 'Image';
  static const String filterAudio = 'Audio';
  static const String filterCode = 'Code';
  static const String filterProductivity = 'Productivity';

  // Section headers
  static const String sectionPopular = 'POPULAR';
  static const String sectionWritingContent = 'WRITING & CONTENT';
  static const String sectionAudioVideo = 'AUDIO & VIDEO';
  static const String sectionProductivity = 'PRODUCTIVITY';
  static const String sectionDesignDev = 'DESIGN & DEV';

  // Search
  static const String searchToolsHint = 'Search tools...';

  // Tool descriptions
  static const String toolChatDescription =
      'Chat naturally with an AI assistant for any question.';
  static const String toolWriterDescription =
      'Generate articles, emails, and creative writing in seconds.';
  static const String toolImageGeneratorDescription =
      'Turn text prompts into stunning AI-generated images.';
  static const String toolSummarizerDescription =
      'Condense long documents into clear, concise summaries.';
  static const String toolTranslatorDescription =
      'Translate text between languages instantly.';
  static const String toolCodeAssistantDescription =
      'Get help writing, debugging, and explaining code.';

  // Writing & Content descriptions
  static const String toolGrammarCheckerDescription =
      'Fix grammar, spelling, and tone instantly.';
  static const String toolParaphraserDescription =
      'Rewrite text while keeping the meaning.';
  static const String toolSeoGeneratorDescription =
      'Create SEO-optimized blogs & descriptions.';
  static const String toolEmailGeneratorDescription =
      'Draft professional emails in seconds.';

  // Audio & Video descriptions
  static const String toolVoiceGeneratorDescription =
      'Convert text to natural-sounding speech.';
  static const String toolTranscriptionDescription =
      'Turn audio & video into accurate text.';
  static const String toolVideoScriptDescription =
      'Generate scripts for reels & YouTube.';

  // Productivity descriptions
  static const String toolPdfAssistantDescription =
      'Chat with, summarize, or extract from PDFs.';
  static const String toolPresentationMakerDescription =
      'Build slide decks from a single prompt.';
  static const String toolResumeBuilderDescription =
      'Create ATS-friendly resumes fast.';
  static const String toolDataAnalyzerDescription =
      'Get insights from spreadsheets instantly.';

  // Design & Dev descriptions
  static const String toolLogoGeneratorDescription =
      'Design a brand logo in minutes.';
  static const String toolBackgroundRemoverDescription =
      'Remove image backgrounds instantly.';
  static const String toolSqlGeneratorDescription =
      'Generate SQL queries from plain text.';
  static const String toolRegexGeneratorDescription =
      'Build and test regex patterns easily.';

  // ---------------------------------------------------------------------
  // AI Chat
  // ---------------------------------------------------------------------
  static const String chatOnlineStatus = 'Online';
  static const String chatInputHint = 'Type a message...';
  static const String newChatLabel = 'New Chat';
  static const String todayLabel = 'Today';
  static const String imageAttachmentPrompt = 'Sent an image';

  // ---------------------------------------------------------------------
  // Main navigation
  // ---------------------------------------------------------------------
  static const String navDashboard = 'Dashboard';
  static const String navTransactions = 'Transactions';
  static const String navAccounts = 'Accounts';
  static const String navAiChat = 'AI Chat';
  static const String navMore = 'More';

  // ---------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------
  static const String profileScreenTitle = 'Profile';
  static const String currentPlanLabel = 'Current Plan';
  static const String upgradeLabel = 'Upgrade';
  static const String menuSettings = 'Settings';
  static const String menuHelp = 'Help & Support';
  static const String menuSignOut = 'Sign Out';
  static const String signOutConfirmTitle = 'Sign Out';
  static const String signOutConfirmMessage =
      'Are you sure you want to sign out?';

  static const String verifiedAccount = 'Verified Account';
  static const String creditsUsedLabel = 'Credits Used';
  static const String creditsValue = '32,000 / 50,000';
  static const String resetInfo = 'Resets in 12 days · Nov 1, 2026';

  static const String accountSectionTitle = 'ACCOUNT';
  static const String billingSectionTitle = 'BILLING';

  static const String editProfileLabel = 'Edit Profile';
  static const String passwordSecurityLabel = 'Password & Security';

  static const String paymentMethodsLabel = 'Payment Methods';
  static const String billingHistoryLabel = 'Billing History';
  static const String manageSubscriptionLabel = 'Manage Subscription';

  // ---------------------------------------------------------------------
  // Profile Feature Sub-screens
  // ---------------------------------------------------------------------

  // API Keys
  static const String apiKeysScreenTitle = 'API Keys';
  static const String apiKeysScreenSubtitle =
      'Manage access tokens for programmatic API access';
  static const String activeSecretKeysHeader = 'Active Secret Keys';
  static const String generateNewKeyLabel = 'Generate New Key';
  static const String apiKeyGeneratedMessage =
      'New API Key generated successfully!';
  static const String apiKeyCopiedMessage = 'Key copied to clipboard';
  static const String apiKeyRevokedMessage = 'API key revoked';

  // Billing History
  static const String billingHistoryScreenTitle = 'Billing History';
  static const String billingHistoryScreenSubtitle =
      'View past invoices and payment receipts';
  static const String downloadInvoiceMessage = 'Downloading invoice...';
  static const String totalSpentLabel = 'Total Spent (2026)';
  static const String allPaidBadge = 'All Paid';
  static const String monthlySpendingChartLabel = 'Monthly Spending Chart';
  static const String pastInvoicesHeader = 'Past Invoices';

  // Edit Profile
  static const String editProfileScreenTitle = 'Edit Profile';
  static const String editProfileScreenSubtitle =
      'Update your personal information and avatar';
  static const String profileSavedMessage = 'Profile updated successfully!';
  static const String bioLabel = 'Bio';

  // Integrations
  static const String integrationsScreenTitle = 'Integrations';
  static const String integrationsScreenSubtitle =
      'Connect NexaAi with your favorite tools and platforms';
  static const String appConnectedBadge = 'Connected';
  static const String integrationGithubName = 'GitHub';
  static const String integrationGithubDesc =
      'Sync repositories, issues & pull requests with AI';
  static const String integrationGoogleDriveName = 'Google Drive';
  static const String integrationGoogleDriveDesc =
      'Import documents & spreadsheets directly into workspace';
  static const String integrationSlackName = 'Slack';
  static const String integrationSlackDesc =
      'Receive AI bot notifications & answer questions in channels';
  static const String integrationZapierName = 'Zapier';
  static const String integrationZapierDesc =
      'Connect 5,000+ automated workflow apps';

  static String integrationConnectedMessage(String name) =>
      '$name connected';
  static String integrationDisconnectedMessage(String name) =>
      '$name disconnected';

  // Password & Security
  static const String passwordSecurityScreenTitle = 'Password & Security';
  static const String passwordSecurityScreenSubtitle =
      'Manage your password and authentication settings';
  static const String twoFactorSubtitle = 'Add an extra layer of security';
  static const String changePasswordHeader = 'Change Password';
  static const String currentPasswordLabel = 'Current Password';
  static const String passwordUpdatedMessage = 'Password updated successfully!';
  static const String twoFactorEnabledMessage = '2FA Enabled';
  static const String twoFactorDisabledMessage = '2FA Disabled';

  // Payment Methods
  static const String paymentMethodsScreenTitle = 'Payment Methods';
  static const String paymentMethodsScreenSubtitle =
      'Manage saved cards and billing options';
  static const String savedCardsHeader = 'Saved Cards';
  static const String addPaymentMethodLabel = 'Add Payment Method';
  static const String addCardModalTitle = 'Add Payment Method';
  static const String addCardModalSubtitle =
      'Your card details are encrypted and secure.';
  static const String cardholderNameLabel = 'Cardholder Name';
  static const String cardNumberLabel = 'Card Number';
  static const String expiryDateLabel = 'Expiry Date';
  static const String cvvLabel = 'CVV';
  static const String addCardButtonLabel = 'Add Card';
  static const String sslSecurityNote = 'Secured with 256-bit SSL encryption';
  static const String makeDefaultLabel = 'Make Default';
  static const String removeLabel = 'Remove';
  static const String defaultBadge = 'DEFAULT';

  // Team Members
  static const String teamMembersScreenTitle = 'Team Members';
  static const String teamMembersScreenSubtitle =
      'Manage workspace access and seat allocation';
  static const String teamSeatsAllocationLabel = 'Team Seats Allocation';
  static const String workspaceMembersLabel = 'Workspace Members';
  static const String inviteLabel = 'Invite';
  static const String inviteMemberLabel = 'Invite Member';
  static const String sendInviteLabel = 'Send Invite';
  static const String memberInvitedMessage = 'Invitation sent successfully!';
  static const String roleOwner = 'Owner';
  static const String roleAdmin = 'Admin';
  static const String roleMember = 'Member';

  // Usage & Credits
  static const String usageCreditsScreenTitle = 'Usage & Credits';
  static const String usageCreditsScreenSubtitle =
      'Your AI usage at a glance';
  static const String creditsLeftLabel = 'Credits Left';
  static const String usedTodayLabel = 'Used Today';
  static const String monthlyLabel = 'Monthly';
  static const String tabCreditTrend = 'Credit Trend';
  static const String tabDailyCalls = 'Daily Calls';
  static const String monthlyLimitUsageLabel = 'Monthly Limit Usage';

  // Workspace Settings
  static const String workspaceSettingsScreenTitle = 'Workspace Settings';
  static const String workspaceSettingsScreenSubtitle =
      'Configure team workspace preferences and default models';
  static const String workspaceNameLabel = 'Workspace Name';
  static const String workspaceSlugLabel = 'Workspace URL Slug';
  static const String workspaceUpdatedMessage =
      'Workspace settings saved successfully!';

  static const String settingsSubtitle =
      'Appearance, notifications, AI preferences';
  static const String deleteAccountLabel = 'Delete Account';
  static const String buildVersionText = 'Version 2.4.1 (Build 108)';

  // ---------------------------------------------------------------------
  // Subscription
  // ---------------------------------------------------------------------
  static const String subscriptionScreenTitle = 'Subscription';
  static const String subscriptionScreenSubtitle =
      'Choose the plan that fits your needs.';
  static const String billingMonthly = 'Monthly';
  static const String billingYearly = 'Yearly';
  static const String mostPopularBadge = 'Most Popular';
  static const String currentPlanBadge = 'Current Plan';
  static const String getStartedLabel = 'Get Started';
  static const String subscribeComingSoonMessage =
      'Subscriptions are coming soon.';

  static String pricePerMonth(String amount) => '\$$amount/mo';
  static String pricePerYear(String amount) => '\$$amount/yr';

  static const String planFree = 'Free';
  static const String planPro = 'Pro';
  static const String planBusiness = 'Business';
  static const String activeStatusBadge = 'ACTIVE';

  static const String featureBasicChat = 'Basic AI chat access';
  static const String featureLimitedMessages = '20 messages per day';
  static const String featureStandardSpeed = 'Standard response speed';
  static const String featureUnlimitedChat = 'Unlimited AI chat access';
  static const String featureAllTools = 'Access to all AI tools';
  static const String featurePrioritySpeed = 'Priority response speed';
  static const String featureAdvancedModels =
      'Access to advanced AI models';
  static const String featureTeamSeats = '5 team member seats';
  static const String featureApiAccess = 'API access for integrations';
  static const String featureDedicatedSupport = 'Dedicated priority support';

  // ---------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------
  static const String settingsScreenTitle = 'Settings';

  static const String appearanceSectionTitle = 'Appearance';
  static const String themeModeLabel = 'Theme';
  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String themeSystem = 'System';

  static const String notificationsSectionTitle = 'Notifications';
  static const String pushNotificationsLabel = 'Push Notifications';
  static const String pushNotificationsDescription =
      'Get notified about new messages and updates.';
  static const String emailNotificationsLabel = 'Email Notifications';
  static const String emailNotificationsDescription =
      'Receive product updates via email.';

  static const String securitySectionTitle = 'Security';
  static const String twoFactorAuthLabel = 'Two-Factor Authentication';
  static const String activeSessionsLabel = 'Active Sessions';
  static const String activeSessionsSubtitle = '3 active devices';

  static const String generalSectionTitle = 'General';
  static const String languageLabel = 'Language';
  static const String languageValue = 'English';
  static const String fontSizeLabel = 'Font Size';
  static const String fontSizeValue = 'Medium';
  static const String soundEffectsLabel = 'Sound Effects';
  static const String autoUpdateAppLabel = 'Auto-Update App';
  static const String storageUsageLabel = 'Storage Usage';
  static const String storageUsageValue = '380 MB / 1 GB';
  static const String clearCacheLabel = 'Clear Cache';
  static const String clearCacheSuccessMessage = 'Cache cleared successfully.';

  static const String supportLegalSectionTitle = 'Support & Legal';
  static const String sendFeedbackLabel = 'Send Feedback';
  static const String aboutAppLabel = 'About App';
  static const String termsOfServiceLabel = 'Terms of Service';
  static const String privacyPolicyLabel = 'Privacy Policy';

  static const String advancedSectionTitle = 'Advanced';
  static const String exportMyDataLabel = 'Export My Data';
  static const String resetAllSettingsLabel = 'Reset All Settings';
  static const String resetAllSettingsConfirmMessage =
      'Are you sure you want to reset all settings to default values?';
  static const String settingsResetSuccessMessage =
      'Settings reset to defaults.';

  static const String appVersionNumber = '1.0.0';
  static String appVersion(String version) => 'Version $version';

  // Option picker sheet
  static const String selectOptionCancel = 'Cancel';

  // Language options
  static const List<String> languageOptions = [
    'English',
    'Spanish',
    'French',
    'German',
    'Portuguese',
    'Japanese',
    'Hindi',
    'Bengali',
  ];

  // Font Size options
  static const String fontSizeSmall = 'Small';
  static const String fontSizeMedium = 'Medium';
  static const String fontSizeLarge = 'Large';
  static const String fontSizeExtraLarge = 'Extra Large';


  // Active Sessions screen
  static const String activeSessionsScreenTitle = 'Active Sessions';
  static const String thisDeviceLabel = 'This device';
  static const String signOutLabel = 'Sign Out';
  static const String signOutAllOthersLabel = 'Sign Out All Other Sessions';
  static const String signOutSessionConfirmTitle = 'Sign Out Device';
  static const String signOutSessionConfirmMessage =
      'This device will be signed out of your account immediately.';
  static const String sessionSignedOutMessage = 'Device signed out.';
  static const String allOtherSessionsSignedOutMessage =
      'All other sessions have been signed out.';

  // Send Feedback sheet
  static const String sendFeedbackTitle = 'Send Feedback';
  static const String sendFeedbackHint =
      'Tell us what\'s working well or what could be better...';
  static const String submitFeedbackLabel = 'Submit Feedback';
  static const String feedbackRequiredMessage =
      'Please enter some feedback before submitting.';
  static const String feedbackSubmittedMessage =
      'Thanks! Your feedback has been submitted.';

  // About App screen
  static const String aboutAppDescription =
      'RimRid Finance brings your accounts, spending, and budgets into '
      'one clean, fast, AI-first app -- track transactions, understand '
      'your spending, and ask your AI assistant anything about your '
      'money, all in one place.';
  static const String aboutAppMadeWith = 'Made with Flutter';
  static const String aboutAppCopyright =
      '© 2026 RimRid Finance. All rights reserved.';

  // Export My Data
  static const String exportDataConfirmTitle = 'Export My Data';
  static const String exportDataConfirmMessage =
      'We\'ll prepare a copy of your account data and email you a '
      'download link. This may take a few minutes.';
  static const String exportDataRequestedMessage =
      'Export requested. We\'ll email you a download link shortly.';

  // ---------------------------------------------------------------------
  // Terms of Service (placeholder legal content)
  // ---------------------------------------------------------------------
  static const String legalLastUpdated = 'Last updated: January 2026';

  static const String termsSection1Heading = '1. Acceptance of Terms';
  static const String termsSection1Body =
      'By creating an account or using NexaAi, you agree to be bound by '
      'these Terms of Service. If you do not agree, please do not use '
      'the app.';
  static const String termsSection2Heading = '2. Using Our Service';
  static const String termsSection2Body =
      'You agree to use NexaAi only for lawful purposes and in accordance '
      'with these terms. You are responsible for any content you submit '
      'and for keeping your account credentials secure.';
  static const String termsSection3Heading = '3. Subscriptions & Billing';
  static const String termsSection3Body =
      'Paid plans renew automatically until cancelled. You can manage or '
      'cancel your subscription at any time from Profile > Subscription.';
  static const String termsSection4Heading = '4. AI-Generated Content';
  static const String termsSection4Body =
      'Responses are generated by AI models and may occasionally be '
      'inaccurate or incomplete. Review important content before relying '
      'on it.';
  static const String termsSection5Heading = '5. Termination';
  static const String termsSection5Body =
      'We may suspend or terminate access to accounts that violate these '
      'terms. You may stop using NexaAi and delete your account at any '
      'time.';

  // ---------------------------------------------------------------------
  // Privacy Policy (placeholder legal content)
  // ---------------------------------------------------------------------
  static const String privacySection1Heading = '1. Information We Collect';
  static const String privacySection1Body =
      'We collect account details (like your name and email) and usage '
      'data (like conversations and preferences) to provide and improve '
      'NexaAi.';
  static const String privacySection2Heading = '2. How We Use Your Data';
  static const String privacySection2Body =
      'Your data is used to operate the app, personalize your experience, '
      'and communicate important updates. We do not sell your personal '
      'data.';
  static const String privacySection3Heading = '3. Data Storage & Security';
  static const String privacySection3Body =
      'Conversations are encrypted in transit and at rest. You can adjust '
      'how long chat history is kept from Settings > AI Preferences.';
  static const String privacySection4Heading = '4. Third-Party Sharing';
  static const String privacySection4Body =
      'We only share data with third parties when required to operate the '
      'service (e.g. cloud infrastructure) or when legally required.';
  static const String privacySection5Heading = '5. Your Choices';
  static const String privacySection5Body =
      'You can export or delete your data at any time from Settings > '
      'Advanced, and manage notification preferences from Settings > '
      'Notifications.';

  // ---------------------------------------------------------------------
  // Help & Support
  // ---------------------------------------------------------------------
  static const String helpScreenTitle = 'Help & Support';
  static const String helpScreenSubtitle = "We're here to help.";
  static const String contactSupportTitle = 'Need more help?';
  static const String contactSupportDescription =
      'Reach out and our team will get back to you shortly.';
  static const String supportEmail = 'support@NexaAi.app';
  static const String copyEmailLabel = 'Copy Email';
  static const String emailCopiedMessage = 'Email copied to clipboard.';
  static const String faqSectionTitle = 'Frequently Asked Questions';

  static const String faqQuestion1 = 'How do I start a new chat?';
  static const String faqAnswer1 =
      'Tap the "Ask AI anything" bar on the Home screen, or open any tool '
      'from AI Tools, to start a new conversation.';
  static const String faqQuestion2 = 'Can I use NexaAi for free?';
  static const String faqAnswer2 =
      'Yes! The Free plan gives you basic chat access. Upgrade anytime '
      'from the Profile tab for unlimited access and more tools.';
  static const String faqQuestion3 = 'How do I change the app theme?';
  static const String faqAnswer3 =
      'Go to Profile > Settings > Appearance and choose Light, Dark, or '
      'System.';
  static const String faqQuestion4 = 'Is my data secure?';
  static const String faqAnswer4 =
      'We take privacy seriously. Your conversations are encrypted and '
      'never shared with third parties.';
  static const String faqQuestion5 = 'How do I cancel my subscription?';
  static const String faqAnswer5 =
      'Visit Profile > Subscription to manage or cancel your plan at any '
      'time.';

  // ---------------------------------------------------------------------
  // AI tool workspace (Writer / Summarizer / Code Assistant)
  // ---------------------------------------------------------------------
  static const String promptInputLabel = 'Prompt';
  static const String promptInputHint = 'Type your prompt here...';
  static const String generateLabel = 'Generate';
  static const String resultLabel = 'Result';
  static const String promptRequiredMessage = 'Enter a prompt to continue.';

  // ---------------------------------------------------------------------
  // Image Generator
  // ---------------------------------------------------------------------
  static const String imageGeneratorPromptHint =
      'Describe the image you want to create...';
  static const String generateImageLabel = 'Generate Image';
  static const String generatedImagesLabel = 'Generated Images';

  // ---------------------------------------------------------------------
  // Translator
  // ---------------------------------------------------------------------
  static const String translatorSourceHint = 'Enter text to translate...';
  static const String translateLabel = 'Translate';
  static const String translationLabel = 'Translation';
  static const String languageEnglish = 'English';
  static const String languageSpanish = 'Spanish';

  // ---------------------------------------------------------------------
  // Logo Generator / Presentation Maker (visual grid workspace)
  // ---------------------------------------------------------------------
  static const String logoGeneratorPromptHint =
      'Describe your brand or logo idea...';
  static const String generateLogoLabel = 'Generate Logo';
  static const String generatedLogosLabel = 'Generated Logos';
  static const String presentationMakerPromptHint =
      'Describe your presentation topic...';
  static const String generateSlidesLabel = 'Generate Slides';
  static const String generatedSlidesLabel = 'Generated Slides';

  // ---------------------------------------------------------------------
  // Upload workspace (Transcription / PDF Assistant / Data Analyzer /
  // Background Remover)
  // ---------------------------------------------------------------------
  static const String uploadFileLabel = 'Upload File';
  static const String uploadFileHint = 'Tap to choose a file from your device';
  static const String changeFileLabel = 'Change File';
  static const String fileRequiredMessage = 'Upload a file to continue.';
  static const String processLabel = 'Process';
  static const String uploadImageLabel = 'Upload Image';
  static const String uploadImageHint =
      'Tap to choose an image from your device';
  static const String removeBackgroundLabel = 'Remove Background';
  static const String beforeLabel = 'Before';
  static const String afterLabel = 'After';

  // ---------------------------------------------------------------------
  // Voice Generator
  // ---------------------------------------------------------------------
  static const String voiceGeneratorPromptHint =
      'Type the text you want to convert to speech...';
  static const String generateSpeechLabel = 'Generate Speech';
  static const String generatedAudioLabel = 'Generated Audio';

  // ---------------------------------------------------------------------
  // Tool-specific UI labels
  // ---------------------------------------------------------------------
  static const String topicLabel = 'Topic / Keyword';
  static const String topicHint = 'e.g. productivity tips for remote teams';
  static const String secondaryKeywordsLabel = 'Secondary Keywords';
  static const String secondaryKeywordsHint = 'comma-separated keywords';
  static const String contentTypeLabel = 'Content Type';
  static const String toneLabel = 'Tone';
  static const String seoScoreLabel = 'SEO Score';
  static const String seoPreviewLabel = 'Preview';
  static const String recipientLabel = 'Recipient';
  static const String recipientHint = 'e.g. hiring@company.com';
  static const String subjectLabel = 'Subject';
  static const String subjectHint = 'Leave blank to auto-generate';
  static const String keyPointsLabel = 'Key Points';
  static const String keyPointsHint = 'What should the email cover?';
  static const String emailPreviewLabel = 'Email Preview';
  static const String writingModeLabel = 'Writing Mode';
  static const String inputEditorLabel = 'Your Draft';
  static const String outputEditorLabel = 'Generated Output';
  static const String sourceTextLabel = 'Source Text';
  static const String summaryLengthLabel = 'Summary Length';
  static const String wordsReducedLabel = 'Words reduced';
  static const String issuesFoundLabel = 'Issues found';
  static const String correctedTextLabel = 'Corrected Text';
  static const String originalTextLabel = 'Original';
  static const String paraphrasedTextLabel = 'Paraphrased';
  static const String programmingLanguageLabel = 'Language';
  static const String taskDescriptionLabel = 'Describe your task';
  static const String codeOutputLabel = 'Generated Code';
  static const String platformLabel = 'Platform';
  static const String durationLabel = 'Duration';
  static const String scriptSectionsLabel = 'Script Sections';
  static const String jobTitleLabel = 'Job Title';
  static const String experienceLabel = 'Years of Experience';
  static const String skillsLabel = 'Skills';
  static const String resumePreviewLabel = 'Resume Preview';
  static const String databaseLabel = 'Database';
  static const String schemaHintLabel = 'Schema (optional)';
  static const String schemaHint = 'e.g. users(id, name, email)';
  static const String sqlOutputLabel = 'Generated SQL';
  static const String patternDescriptionLabel = 'Describe the pattern';
  static const String testStringLabel = 'Test String';
  static const String regexOutputLabel = 'Generated Pattern';
  static const String aspectRatioLabel = 'Aspect Ratio';
  static const String imageStyleLabel = 'Style';
  static const String imagePreviewLabel = 'Preview';
  static const String brandNameLabel = 'Brand Name';
  static const String taglineLabel = 'Tagline';
  static const String industryLabel = 'Industry';
  static const String logoStyleLabel = 'Logo Style';
  static const String audienceLabel = 'Audience';
  static const String slideCountLabel = 'Number of Slides';
  static const String transcriptLabel = 'Transcript';
  static const String transcribeLabel = 'Transcribe';
  static const String processingAudioLabel = 'Processing audio...';
  static const String pdfActionsLabel = 'What would you like to do?';
  static const String pdfQuestionHint = 'Ask a question about the document...';
  static const String insightsLabel = 'Insights';
  static const String dataPreviewLabel = 'Data Preview';
  static const String voiceLabel = 'Voice';
  static const String speedLabel = 'Speed';
  static const String selectVoiceLabel = 'Select a voice';
  static const String copyLabel = 'Copy';

  // ---------------------------------------------------------------------
  // Attachment picker (Chat input, upload workspaces)
  // ---------------------------------------------------------------------
  static const String addAttachmentTitle = 'Add Attachment';
  static const String attachmentCameraLabel = 'Camera';
  static const String attachmentCameraSubtitle = 'Take a new photo';
  static const String attachmentGalleryLabel = 'Photos & Videos';
  static const String attachmentGallerySubtitle = 'Choose from your library';
  static const String attachmentDocumentLabel = 'Document';
  static const String attachmentDocumentSubtitle = 'Choose a file to upload';
  static const String attachmentPermissionDeniedMessage =
      'Permission denied. Enable access in your device settings.';
  static String attachmentAddedMessage(String fileName) =>
      'Attached: $fileName';
}
