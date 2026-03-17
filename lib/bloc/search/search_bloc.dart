import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/search_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService service;

  SearchBloc(this.service) : super(SearchInitial()) {
    on<SearchByCompanyEvent>((e, emit) {
      final res = service.byCompany(e.company);
      emit(res.isEmpty ? SearchEmpty() : SearchResults(res));
    });

    on<SearchByDateEvent>((e, emit) {
      final res = service.byDate(e.date);
      emit(res.isEmpty ? SearchEmpty() : SearchResults(res));
    });

    on<SearchByPlateEvent>((e, emit) {
      final res = service.byPlate(e.plate);
      emit(res.isEmpty ? SearchEmpty() : SearchResults(res));
    });

    on<ClearSearchEvent>((e, emit) => emit(SearchInitial()));
  }
}