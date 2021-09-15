// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStoreBase, Store {
  final _$isLoadingAtom = Atom(name: '_LoginStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$msgAlertAtom = Atom(name: '_LoginStoreBase.msgAlert');

  @override
  MessageAlert? get msgAlert {
    _$msgAlertAtom.reportRead();
    return super.msgAlert;
  }

  @override
  set msgAlert(MessageAlert? value) {
    _$msgAlertAtom.reportWrite(value, super.msgAlert, () {
      super.msgAlert = value;
    });
  }

  final _$userSingInAtom = Atom(name: '_LoginStoreBase.userSingIn');

  @override
  User? get userSingIn {
    _$userSingInAtom.reportRead();
    return super.userSingIn;
  }

  @override
  set userSingIn(User? value) {
    _$userSingInAtom.reportWrite(value, super.userSingIn, () {
      super.userSingIn = value;
    });
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
msgAlert: ${msgAlert},
userSingIn: ${userSingIn}
    ''';
  }
}
