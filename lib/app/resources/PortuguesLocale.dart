import 'package:date_format/date_format.dart';

class PortuguesLocale implements DateLocale {
  const PortuguesLocale();

  final List<String> monthsShort = const [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];

  final List<String> monthsLong = const [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto	',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  final List<String> daysShort = const [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sab',
    'Dom'
  ];

  final List<String> daysLong = const [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  @override
  String get am => "AM";

  @override
  String get pm => "PM";
}