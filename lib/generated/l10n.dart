// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Revo - Focused Goals`
  String get name_app {
    return Intl.message(
      'Revo - Focused Goals',
      name: 'name_app',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get label_login {
    return Intl.message(
      'Login',
      name: 'label_login',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get label_email {
    return Intl.message(
      'E-mail',
      name: 'label_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get label_password {
    return Intl.message(
      'Password',
      name: 'label_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get label_enter {
    return Intl.message(
      'Login',
      name: 'label_enter',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get label_or {
    return Intl.message(
      'OR',
      name: 'label_or',
      desc: '',
      args: [],
    );
  }

  /// `Login with Google`
  String get label_login_with_google {
    return Intl.message(
      'Login with Google',
      name: 'label_login_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Login with Facebook`
  String get label_login_with_facebook {
    return Intl.message(
      'Login with Facebook',
      name: 'label_login_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Forgot the password`
  String get label_forgot_password {
    return Intl.message(
      'Forgot the password',
      name: 'label_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `No account`
  String get label_not_rigister {
    return Intl.message(
      'No account',
      name: 'label_not_rigister',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get title_register_email {
    return Intl.message(
      'Register',
      name: 'title_register_email',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get label_name {
    return Intl.message(
      'Name',
      name: 'label_name',
      desc: '',
      args: [],
    );
  }

  /// `Confirm email`
  String get label_confirm_email {
    return Intl.message(
      'Confirm email',
      name: 'label_confirm_email',
      desc: '',
      args: [],
    );
  }

  /// `The confirmation email does not match.`
  String get msg_error_email_diff {
    return Intl.message(
      'The confirmation email does not match.',
      name: 'msg_error_email_diff',
      desc: '',
      args: [],
    );
  }

  /// `Oops!`
  String get title_msg_error {
    return Intl.message(
      'Oops!',
      name: 'title_msg_error',
      desc: '',
      args: [],
    );
  }

  /// `You already have an account with this email.`
  String get msg_error_already_in_use {
    return Intl.message(
      'You already have an account with this email.',
      name: 'msg_error_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Email is already used for login with Facebook or Google.`
  String get msg_error_already_email_diff_credential {
    return Intl.message(
      'Email is already used for login with Facebook or Google.',
      name: 'msg_error_already_email_diff_credential',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get msg_error_email_invalid {
    return Intl.message(
      'Invalid email',
      name: 'msg_error_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Unable to login.`
  String get msg_error_generic_user_login {
    return Intl.message(
      'Unable to login.',
      name: 'msg_error_generic_user_login',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect login or password`
  String get msg_error_already_credintial_in_use {
    return Intl.message(
      'Incorrect login or password',
      name: 'msg_error_already_credintial_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Unable to save user credentials`
  String get msg_error_not_possible_save_user {
    return Intl.message(
      'Unable to save user credentials',
      name: 'msg_error_not_possible_save_user',
      desc: '',
      args: [],
    );
  }

  /// `Unable to upload profile photo.`
  String get msg_error_not_possible_upload_photo {
    return Intl.message(
      'Unable to upload profile photo.',
      name: 'msg_error_not_possible_upload_photo',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get msg_error_unexpected {
    return Intl.message(
      'An unexpected error occurred',
      name: 'msg_error_unexpected',
      desc: '',
      args: [],
    );
  }

  /// `Your login was created successfully!`
  String get msg_sucess_user_created {
    return Intl.message(
      'Your login was created successfully!',
      name: 'msg_sucess_user_created',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get title_forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'title_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Fill in the email to reset your password.`
  String get msg_fill_email {
    return Intl.message(
      'Fill in the email to reset your password.',
      name: 'msg_fill_email',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email.`
  String get msg_email_invalid {
    return Intl.message(
      'Invalid email.',
      name: 'msg_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `User not found.`
  String get msg_error_user_not_found {
    return Intl.message(
      'User not found.',
      name: 'msg_error_user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get title_msg_sucess {
    return Intl.message(
      'Success',
      name: 'title_msg_sucess',
      desc: '',
      args: [],
    );
  }

  /// `An email has been sent with directions to reset your password.`
  String get msg_sucess_forgot_password {
    return Intl.message(
      'An email has been sent with directions to reset your password.',
      name: 'msg_sucess_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Your account is blocked.`
  String get msg_error_user_block {
    return Intl.message(
      'Your account is blocked.',
      name: 'msg_error_user_block',
      desc: '',
      args: [],
    );
  }

  /// `The email or password is incorrect.`
  String get msg_error_user_or_password_incorrect {
    return Intl.message(
      'The email or password is incorrect.',
      name: 'msg_error_user_or_password_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Okay, you can use another login method.`
  String get msg_error_sign_in_fb_cancelled {
    return Intl.message(
      'Okay, you can use another login method.',
      name: 'msg_error_sign_in_fb_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to login with facebook, please try again later.`
  String get msg_error_sign_in_fb_failed {
    return Intl.message(
      'Failed to login with facebook, please try again later.',
      name: 'msg_error_sign_in_fb_failed',
      desc: '',
      args: [],
    );
  }

  /// `Unable to finalize login, please try again later.`
  String get msg_error_sign_in_fb_in_progress {
    return Intl.message(
      'Unable to finalize login, please try again later.',
      name: 'msg_error_sign_in_fb_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `An account with the same email address but different login credentials already exists. Log in using a provider associated with this email address.`
  String get msg_error_credential_invalid {
    return Intl.message(
      'An account with the same email address but different login credentials already exists. Log in using a provider associated with this email address.',
      name: 'msg_error_credential_invalid',
      desc: '',
      args: [],
    );
  }

  /// `History of daily goals`
  String get label_hist_daily_goal {
    return Intl.message(
      'History of daily goals',
      name: 'label_hist_daily_goal',
      desc: '',
      args: [],
    );
  }

  /// `Daily goals`
  String get label_daily_goals {
    return Intl.message(
      'Daily goals',
      name: 'label_daily_goals',
      desc: '',
      args: [],
    );
  }

  /// `Daily goal`
  String get label_daily_goal {
    return Intl.message(
      'Daily goal',
      name: 'label_daily_goal',
      desc: '',
      args: [],
    );
  }

  /// `Steps`
  String get label_steps {
    return Intl.message(
      'Steps',
      name: 'label_steps',
      desc: '',
      args: [],
    );
  }

  /// `Step`
  String get label_step {
    return Intl.message(
      'Step',
      name: 'label_step',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get label_today {
    return Intl.message(
      'Today',
      name: 'label_today',
      desc: '',
      args: [],
    );
  }

  /// `Your week`
  String get label_your_week {
    return Intl.message(
      'Your week',
      name: 'label_your_week',
      desc: '',
      args: [],
    );
  }

  /// `Your month`
  String get label_your_month {
    return Intl.message(
      'Your month',
      name: 'label_your_month',
      desc: '',
      args: [],
    );
  }

  /// `Daily monitoring of goals`
  String get label_monitor_goal_daily {
    return Intl.message(
      'Daily monitoring of goals',
      name: 'label_monitor_goal_daily',
      desc: '',
      args: [],
    );
  }

  /// `Monthly monitoring of goals`
  String get label_monitor_goal_month {
    return Intl.message(
      'Monthly monitoring of goals',
      name: 'label_monitor_goal_month',
      desc: '',
      args: [],
    );
  }

  /// `Goal`
  String get label_goal {
    return Intl.message(
      'Goal',
      name: 'label_goal',
      desc: '',
      args: [],
    );
  }

  /// `MON`
  String get label_week_day_mon {
    return Intl.message(
      'MON',
      name: 'label_week_day_mon',
      desc: '',
      args: [],
    );
  }

  /// `TUE`
  String get label_week_day_tue {
    return Intl.message(
      'TUE',
      name: 'label_week_day_tue',
      desc: '',
      args: [],
    );
  }

  /// `WED`
  String get label_week_day_wed {
    return Intl.message(
      'WED',
      name: 'label_week_day_wed',
      desc: '',
      args: [],
    );
  }

  /// `THU`
  String get label_week_day_thu {
    return Intl.message(
      'THU',
      name: 'label_week_day_thu',
      desc: '',
      args: [],
    );
  }

  /// `FRI`
  String get label_week_day_fri {
    return Intl.message(
      'FRI',
      name: 'label_week_day_fri',
      desc: '',
      args: [],
    );
  }

  /// `SAT`
  String get label_week_day_sat {
    return Intl.message(
      'SAT',
      name: 'label_week_day_sat',
      desc: '',
      args: [],
    );
  }

  /// `SUN`
  String get label_week_day_sun {
    return Intl.message(
      'SUN',
      name: 'label_week_day_sun',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get label_weekly {
    return Intl.message(
      'Weekly',
      name: 'label_weekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get label_monthly {
    return Intl.message(
      'Monthly',
      name: 'label_monthly',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get label_next {
    return Intl.message(
      'Next',
      name: 'label_next',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get label_finish {
    return Intl.message(
      'Finish',
      name: 'label_finish',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get label_previous {
    return Intl.message(
      'Previous',
      name: 'label_previous',
      desc: '',
      args: [],
    );
  }

  /// `Dream`
  String get label_dream {
    return Intl.message(
      'Dream',
      name: 'label_dream',
      desc: '',
      args: [],
    );
  }

  /// `Dreams`
  String get label_dreams {
    return Intl.message(
      'Dreams',
      name: 'label_dreams',
      desc: '',
      args: [],
    );
  }

  /// `Dream description`
  String get label_description_dream {
    return Intl.message(
      'Dream description',
      name: 'label_description_dream',
      desc: '',
      args: [],
    );
  }

  /// `Choose an image to represent the dream.`
  String get label_choose_image_dream {
    return Intl.message(
      'Choose an image to represent the dream.',
      name: 'label_choose_image_dream',
      desc: '',
      args: [],
    );
  }

  /// `Search the gallery`
  String get label_search_gallery {
    return Intl.message(
      'Search the gallery',
      name: 'label_search_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Searching the Internet`
  String get label_search_internet {
    return Intl.message(
      'Searching the Internet',
      name: 'label_search_internet',
      desc: '',
      args: [],
    );
  }

  /// `What is your dream?`
  String get label_whats_your_dream {
    return Intl.message(
      'What is your dream?',
      name: 'label_whats_your_dream',
      desc: '',
      args: [],
    );
  }

  /// `Steps to conquer`
  String get label_step_to_conquer {
    return Intl.message(
      'Steps to conquer',
      name: 'label_step_to_conquer',
      desc: '',
      args: [],
    );
  }

  /// `Define steps you need to take before you can make the dream come true, as if you were climbing a ladder.`
  String get msg_info_step_conquer {
    return Intl.message(
      'Define steps you need to take before you can make the dream come true, as if you were climbing a ladder.',
      name: 'msg_info_step_conquer',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get label_information {
    return Intl.message(
      'Information',
      name: 'label_information',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get label_add {
    return Intl.message(
      'Add',
      name: 'label_add',
      desc: '',
      args: [],
    );
  }

  /// `Now set daily goals to achieve your steps, focus on the first step and plot your goals, after completion you can add other daily goals.`
  String get msg_info_step_daily_goal {
    return Intl.message(
      'Now set daily goals to achieve your steps, focus on the first step and plot your goals, after completion you can add other daily goals.',
      name: 'msg_info_step_daily_goal',
      desc: '',
      args: [],
    );
  }

  /// `Set a reward that you will get for each completed step. This is very important, after all you deserve it! For example, a special food, going out to a new place, playing a video game, something you really enjoy!`
  String get msg_info_step_reward {
    return Intl.message(
      'Set a reward that you will get for each completed step. This is very important, after all you deserve it! For example, a special food, going out to a new place, playing a video game, something you really enjoy!',
      name: 'msg_info_step_reward',
      desc: '',
      args: [],
    );
  }

  /// `Here you will define something you have to do if your goals are not being met or achieved. It's very simple, what more you need to do to continue climbing the ladder of steps you defined.`
  String get msg_info_step_inflection {
    return Intl.message(
      'Here you will define something you have to do if your goals are not being met or achieved. It\'s very simple, what more you need to do to continue climbing the ladder of steps you defined.',
      name: 'msg_info_step_inflection',
      desc: '',
      args: [],
    );
  }

  /// `Set the level you would like to be charged. Remember to start small as this will validate your performance towards an extraordinary goal.`
  String get msg_info_settings_dream {
    return Intl.message(
      'Set the level you would like to be charged. Remember to start small as this will validate your performance towards an extraordinary goal.',
      name: 'msg_info_settings_dream',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get label_reward {
    return Intl.message(
      'Reward',
      name: 'label_reward',
      desc: '',
      args: [],
    );
  }

  /// `Choose different reward for the week.`
  String get label_choice_diff_reward {
    return Intl.message(
      'Choose different reward for the week.',
      name: 'label_choice_diff_reward',
      desc: '',
      args: [],
    );
  }

  /// `Choose different inflection point for the week.`
  String get label_choice_diff_inflection {
    return Intl.message(
      'Choose different inflection point for the week.',
      name: 'label_choice_diff_inflection',
      desc: '',
      args: [],
    );
  }

  /// `Weekly reward`
  String get label_weekly_reward {
    return Intl.message(
      'Weekly reward',
      name: 'label_weekly_reward',
      desc: '',
      args: [],
    );
  }

  /// `Inflection point`
  String get label_inflection_point {
    return Intl.message(
      'Inflection point',
      name: 'label_inflection_point',
      desc: '',
      args: [],
    );
  }

  /// `Inflection point for week`
  String get label_inflection_point_weekly {
    return Intl.message(
      'Inflection point for week',
      name: 'label_inflection_point_weekly',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get label_settings {
    return Intl.message(
      'Settings',
      name: 'label_settings',
      desc: '',
      args: [],
    );
  }

  /// `Choose a representation color`
  String get label_choice_color_dream {
    return Intl.message(
      'Choose a representation color',
      name: 'label_choice_color_dream',
      desc: '',
      args: [],
    );
  }

  /// `Weekly goal`
  String get label_weekly_goal {
    return Intl.message(
      'Weekly goal',
      name: 'label_weekly_goal',
      desc: '',
      args: [],
    );
  }

  /// `Monthly goal`
  String get label_monthly_goal {
    return Intl.message(
      'Monthly goal',
      name: 'label_monthly_goal',
      desc: '',
      args: [],
    );
  }

  /// `Disabled`
  String get label_disabled {
    return Intl.message(
      'Disabled',
      name: 'label_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get label_beginner {
    return Intl.message(
      'Beginner',
      name: 'label_beginner',
      desc: '',
      args: [],
    );
  }

  /// `Moderate`
  String get label_moderate {
    return Intl.message(
      'Moderate',
      name: 'label_moderate',
      desc: '',
      args: [],
    );
  }

  /// `out of average`
  String get label_out_average {
    return Intl.message(
      'out of average',
      name: 'label_out_average',
      desc: '',
      args: [],
    );
  }

  /// `Extraordinary`
  String get label_extraordinary {
    return Intl.message(
      'Extraordinary',
      name: 'label_extraordinary',
      desc: '',
      args: [],
    );
  }

  /// `On hold`
  String get label_on_hold {
    return Intl.message(
      'On hold',
      name: 'label_on_hold',
      desc: '',
      args: [],
    );
  }

  /// `New Dream`
  String get label_new_dream {
    return Intl.message(
      'New Dream',
      name: 'label_new_dream',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get label_home {
    return Intl.message(
      'Home',
      name: 'label_home',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get label_statistics {
    return Intl.message(
      'Statistics',
      name: 'label_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Challenges`
  String get label_challenges {
    return Intl.message(
      'Challenges',
      name: 'label_challenges',
      desc: '',
      args: [],
    );
  }

  /// `Create focus`
  String get label_create_focus {
    return Intl.message(
      'Create focus',
      name: 'label_create_focus',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get label_rank {
    return Intl.message(
      'Rank',
      name: 'label_rank',
      desc: '',
      args: [],
    );
  }

  /// `Archived dreams`
  String get label_archived_dreams {
    return Intl.message(
      'Archived dreams',
      name: 'label_archived_dreams',
      desc: '',
      args: [],
    );
  }

  /// `No dreams were filed.`
  String get msg_dream_not_archived {
    return Intl.message(
      'No dreams were filed.',
      name: 'msg_dream_not_archived',
      desc: '',
      args: [],
    );
  }

  /// `To Restore`
  String get label_restore {
    return Intl.message(
      'To Restore',
      name: 'label_restore',
      desc: '',
      args: [],
    );
  }

  /// `Dreams completed`
  String get label_dreams_completed {
    return Intl.message(
      'Dreams completed',
      name: 'label_dreams_completed',
      desc: '',
      args: [],
    );
  }

  /// `No dream has been realized yet, but I'm sure it will soon.`
  String get msg_no_dreams_completed {
    return Intl.message(
      'No dream has been realized yet, but I\'m sure it will soon.',
      name: 'msg_no_dreams_completed',
      desc: '',
      args: [],
    );
  }

  /// `Free content`
  String get label_free_content {
    return Intl.message(
      'Free content',
      name: 'label_free_content',
      desc: '',
      args: [],
    );
  }

  /// `Social media`
  String get label_social_media {
    return Intl.message(
      'Social media',
      name: 'label_social_media',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send an email, make sure you have configured the email app on your mobile.`
  String get msg_erro_no_register_email {
    return Intl.message(
      'Unable to send an email, make sure you have configured the email app on your mobile.',
      name: 'msg_erro_no_register_email',
      desc: '',
      args: [],
    );
  }

  /// `Hi Fernando, `
  String get label_start_email {
    return Intl.message(
      'Hi Fernando, ',
      name: 'label_start_email',
      desc: '',
      args: [],
    );
  }

  /// `REVO - Focused goals`
  String get label_title_app {
    return Intl.message(
      'REVO - Focused goals',
      name: 'label_title_app',
      desc: '',
      args: [],
    );
  }

  /// `Site`
  String get label_site {
    return Intl.message(
      'Site',
      name: 'label_site',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get label_contact {
    return Intl.message(
      'Contact',
      name: 'label_contact',
      desc: '',
      args: [],
    );
  }

  /// `Youtube`
  String get label_youtube {
    return Intl.message(
      'Youtube',
      name: 'label_youtube',
      desc: '',
      args: [],
    );
  }

  /// `Instagram`
  String get label_instagram {
    return Intl.message(
      'Instagram',
      name: 'label_instagram',
      desc: '',
      args: [],
    );
  }

  /// `Editar`
  String get label_edit {
    return Intl.message(
      'Editar',
      name: 'label_edit',
      desc: '',
      args: [],
    );
  }

  /// `Realized dream`
  String get label_dream_realized {
    return Intl.message(
      'Realized dream',
      name: 'label_dream_realized',
      desc: '',
      args: [],
    );
  }

  /// `Did you fulfill your dream?`
  String get msg_question_dream_realized {
    return Intl.message(
      'Did you fulfill your dream?',
      name: 'msg_question_dream_realized',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get label_yes {
    return Intl.message(
      'Yes',
      name: 'label_yes',
      desc: '',
      args: [],
    );
  }

  /// `File Dream`
  String get label_file_dream {
    return Intl.message(
      'File Dream',
      name: 'label_file_dream',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to archive this dream? Even if it is archived, you can reactivate it at any time.`
  String get msg_question_file_dream {
    return Intl.message(
      'Do you really want to archive this dream? Even if it is archived, you can reactivate it at any time.',
      name: 'msg_question_file_dream',
      desc: '',
      args: [],
    );
  }

  /// `To file`
  String get label_to_file {
    return Intl.message(
      'To file',
      name: 'label_to_file',
      desc: '',
      args: [],
    );
  }

  /// `Dream choice`
  String get label_dream_choice {
    return Intl.message(
      'Dream choice',
      name: 'label_dream_choice',
      desc: '',
      args: [],
    );
  }

  /// `Dream on hold`
  String get label_dream_hold {
    return Intl.message(
      'Dream on hold',
      name: 'label_dream_hold',
      desc: '',
      args: [],
    );
  }

  /// `In this section, you still don't need to set goals and/or steps for achievement. Just set a preview of your dream so your subconscious knows what you want.`
  String get msg_help_dream_hold {
    return Intl.message(
      'In this section, you still don\'t need to set goals and/or steps for achievement. Just set a preview of your dream so your subconscious knows what you want.',
      name: 'msg_help_dream_hold',
      desc: '',
      args: [],
    );
  }

  /// `Dream with focus`
  String get label_dream_with_focus {
    return Intl.message(
      'Dream with focus',
      name: 'label_dream_with_focus',
      desc: '',
      args: [],
    );
  }

  /// `In this type of dream, you will need to set steps at different levels, like steps on a ladder, and create daily goals that move towards your dream.`
  String get msg_help_dream_with_focus {
    return Intl.message(
      'In this type of dream, you will need to set steps at different levels, like steps on a ladder, and create daily goals that move towards your dream.',
      name: 'msg_help_dream_with_focus',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get label_days {
    return Intl.message(
      'Days',
      name: 'label_days',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get label_archive {
    return Intl.message(
      'Archive',
      name: 'label_archive',
      desc: '',
      args: [],
    );
  }

  /// `Performed`
  String get label_perfomed {
    return Intl.message(
      'Performed',
      name: 'label_perfomed',
      desc: '',
      args: [],
    );
  }

  /// `Social networks`
  String get label_social_network {
    return Intl.message(
      'Social networks',
      name: 'label_social_network',
      desc: '',
      args: [],
    );
  }

  /// `Focus`
  String get label_focus {
    return Intl.message(
      'Focus',
      name: 'label_focus',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get label_level {
    return Intl.message(
      'Level',
      name: 'label_level',
      desc: '',
      args: [],
    );
  }

  /// `Last acess`
  String get last_acess {
    return Intl.message(
      'Last acess',
      name: 'last_acess',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get label_setting {
    return Intl.message(
      'Settings',
      name: 'label_setting',
      desc: '',
      args: [],
    );
  }

  /// `Change profile`
  String get label_change_profile {
    return Intl.message(
      'Change profile',
      name: 'label_change_profile',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get label_dark_theme {
    return Intl.message(
      'Dark theme',
      name: 'label_dark_theme',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get label_exit {
    return Intl.message(
      'Logout',
      name: 'label_exit',
      desc: '',
      args: [],
    );
  }

  /// `Field is required`
  String get label_required_field {
    return Intl.message(
      'Field is required',
      name: 'label_required_field',
      desc: '',
      args: [],
    );
  }

  /// `E-mail is required`
  String get label_required_email {
    return Intl.message(
      'E-mail is required',
      name: 'label_required_email',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get label_required_password {
    return Intl.message(
      'Password is required',
      name: 'label_required_password',
      desc: '',
      args: [],
    );
  }

  /// `Password is invalid`
  String get label_passaword_invalid {
    return Intl.message(
      'Password is invalid',
      name: 'label_passaword_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Your password must be at least 8 digits long`
  String get label_min_character_password {
    return Intl.message(
      'Your password must be at least 8 digits long',
      name: 'label_min_character_password',
      desc: '',
      args: [],
    );
  }

  /// `Password does not match`
  String get label_password_no_match {
    return Intl.message(
      'Password does not match',
      name: 'label_password_no_match',
      desc: '',
      args: [],
    );
  }

  /// `Time to add your first dream!`
  String get msg_not_found_dream {
    return Intl.message(
      'Time to add your first dream!',
      name: 'msg_not_found_dream',
      desc: '',
      args: [],
    );
  }

  /// `Dream is required`
  String get msg_dream_is_required {
    return Intl.message(
      'Dream is required',
      name: 'msg_dream_is_required',
      desc: '',
      args: [],
    );
  }

  /// `The dream description is required`
  String get msg_drescription_dream_required {
    return Intl.message(
      'The dream description is required',
      name: 'msg_drescription_dream_required',
      desc: '',
      args: [],
    );
  }

  /// `The dream image is required`
  String get msg_img_required {
    return Intl.message(
      'The dream image is required',
      name: 'msg_img_required',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one step to conquer`
  String get msg_add_step_required {
    return Intl.message(
      'Add at least one step to conquer',
      name: 'msg_add_step_required',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one daily goal`
  String get msg_add_daily_goal_required {
    return Intl.message(
      'Add at least one daily goal',
      name: 'msg_add_daily_goal_required',
      desc: '',
      args: [],
    );
  }

  /// `The reward is required`
  String get msg_reward_required {
    return Intl.message(
      'The reward is required',
      name: 'msg_reward_required',
      desc: '',
      args: [],
    );
  }

  /// `Inflection point is required`
  String get msg_inflection_point_required {
    return Intl.message(
      'Inflection point is required',
      name: 'msg_inflection_point_required',
      desc: '',
      args: [],
    );
  }

  /// `Choose a representation color`
  String get msg_choice_color_required {
    return Intl.message(
      'Choose a representation color',
      name: 'msg_choice_color_required',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get label_loading {
    return Intl.message(
      'Loading...',
      name: 'label_loading',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
