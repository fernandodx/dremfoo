// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegisterUserStore on _RegisterUserStoreBase, Store {
  final _$isLoadingAtom = Atom(name: '_RegisterUserStoreBase.isLoading');

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

  final _$msgAlertAtom = Atom(name: '_RegisterUserStoreBase.msgAlert');

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

  final _$containerImageAtom =
      Atom(name: '_RegisterUserStoreBase.containerImage');

  @override
  Widget? get containerImage {
    _$containerImageAtom.reportRead();
    return super.containerImage;
  }

  @override
  set containerImage(Widget? value) {
    _$containerImageAtom.reportWrite(value, super.containerImage, () {
      super.containerImage = value;
    });
  }

  final _$onAddImageAsyncAction =
      AsyncAction('_RegisterUserStoreBase.onAddImage');

  @override
  Future onAddImage() {
    return _$onAddImageAsyncAction.run(() => super.onAddImage());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
msgAlert: ${msgAlert},
containerImage: ${containerImage}
    ''';
  }
}
