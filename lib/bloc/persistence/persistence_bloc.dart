import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/vehicle_repository.dart';
import 'persistence_event.dart';
import 'persistence_state.dart';

class PersistenceBloc extends Bloc<PersistenceEvent, PersistenceState> {
  final VehicleRepository repo;

  PersistenceBloc(this.repo) : super(PersistenceIdle()) {
    on<PersistLoadEvent>(_onLoad);
    on<PersistSaveEvent>(_onSave);
  }

  Future<void> _onLoad(PersistLoadEvent event, Emitter<PersistenceState> emit) async {
    try {
      emit(PersistenceSaving());
      await repo.load();
      emit(PersistenceLoaded());
    } catch (e) {
      emit(PersistenceError(e.toString()));
    }
  }

  Future<void> _onSave(PersistSaveEvent event, Emitter<PersistenceState> emit) async {
    try {
      emit(PersistenceSaving()); // مهم: قبل ما يخلص الحفظ
      await repo.save();
      emit(PersistenceIdle());
    } catch (e) {
      emit(PersistenceError(e.toString()));
    }
  }
}