import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchByCompanyEvent extends SearchEvent {
  final String company;
  const SearchByCompanyEvent(this.company);
  @override
  List<Object?> get props => [company];
}

class SearchByDateEvent extends SearchEvent {
  final DateTime date;
  const SearchByDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class SearchByPlateEvent extends SearchEvent {
  final int plate;
  const SearchByPlateEvent(this.plate);
  @override
  List<Object?> get props => [plate];
}

class ClearSearchEvent extends SearchEvent {}