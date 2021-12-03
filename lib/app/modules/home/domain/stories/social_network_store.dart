import 'package:mobx/mobx.dart';

part 'social_network_store.g.dart';

class SocialNetworkStore = _SocialNetworkStoreBase with _$SocialNetworkStore;
abstract class _SocialNetworkStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}