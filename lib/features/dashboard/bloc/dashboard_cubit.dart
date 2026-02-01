import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/date_period.dart';
import '../../../data/models/time_entry.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial());

  void setPeriod(DatePeriod period) {
    emit(state.copyWith(selectedPeriod: period));
  }

  void setEntries(List<TimeEntry> entries) {
    emit(state.copyWith(allEntries: entries, isLoading: false));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  void goToPreviousPeriod() {
    emit(state.copyWith(selectedPeriod: state.selectedPeriod.previous));
  }

  void goToNextPeriod() {
    emit(state.copyWith(selectedPeriod: state.selectedPeriod.next));
  }

  void selectWeek() {
    emit(state.copyWith(selectedPeriod: DatePeriod.week()));
  }

  void selectMonth() {
    emit(state.copyWith(selectedPeriod: DatePeriod.month()));
  }

  void selectYear() {
    emit(state.copyWith(selectedPeriod: DatePeriod.year()));
  }

  void selectCustomPeriod(DateTime start, DateTime end) {
    emit(state.copyWith(selectedPeriod: DatePeriod.custom(start, end)));
  }
}
