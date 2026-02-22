// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HistoryState {
  /// Currently selected date
  DateTime get selectedDate => throw _privateConstructorUsedError;

  /// Stats for the selected date
  DailyStats get selectedDayStats => throw _privateConstructorUsedError;

  /// Stats for the current week
  WeeklyStats get currentWeekStats => throw _privateConstructorUsedError;

  /// Sessions for the selected date
  List<FocusSession> get selectedDaySessions =>
      throw _privateConstructorUsedError;

  /// Dates that have activity (for calendar markers)
  Set<String> get datesWithActivity => throw _privateConstructorUsedError;

  /// Whether the state is loading
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message if something went wrong
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HistoryStateCopyWith<HistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) then) =
      _$HistoryStateCopyWithImpl<$Res, HistoryState>;
  @useResult
  $Res call(
      {DateTime selectedDate,
      DailyStats selectedDayStats,
      WeeklyStats currentWeekStats,
      List<FocusSession> selectedDaySessions,
      Set<String> datesWithActivity,
      bool isLoading,
      String? errorMessage});

  $DailyStatsCopyWith<$Res> get selectedDayStats;
  $WeeklyStatsCopyWith<$Res> get currentWeekStats;
}

/// @nodoc
class _$HistoryStateCopyWithImpl<$Res, $Val extends HistoryState>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? selectedDayStats = null,
    Object? currentWeekStats = null,
    Object? selectedDaySessions = null,
    Object? datesWithActivity = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDayStats: null == selectedDayStats
          ? _value.selectedDayStats
          : selectedDayStats // ignore: cast_nullable_to_non_nullable
              as DailyStats,
      currentWeekStats: null == currentWeekStats
          ? _value.currentWeekStats
          : currentWeekStats // ignore: cast_nullable_to_non_nullable
              as WeeklyStats,
      selectedDaySessions: null == selectedDaySessions
          ? _value.selectedDaySessions
          : selectedDaySessions // ignore: cast_nullable_to_non_nullable
              as List<FocusSession>,
      datesWithActivity: null == datesWithActivity
          ? _value.datesWithActivity
          : datesWithActivity // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DailyStatsCopyWith<$Res> get selectedDayStats {
    return $DailyStatsCopyWith<$Res>(_value.selectedDayStats, (value) {
      return _then(_value.copyWith(selectedDayStats: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WeeklyStatsCopyWith<$Res> get currentWeekStats {
    return $WeeklyStatsCopyWith<$Res>(_value.currentWeekStats, (value) {
      return _then(_value.copyWith(currentWeekStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HistoryStateImplCopyWith<$Res>
    implements $HistoryStateCopyWith<$Res> {
  factory _$$HistoryStateImplCopyWith(
          _$HistoryStateImpl value, $Res Function(_$HistoryStateImpl) then) =
      __$$HistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime selectedDate,
      DailyStats selectedDayStats,
      WeeklyStats currentWeekStats,
      List<FocusSession> selectedDaySessions,
      Set<String> datesWithActivity,
      bool isLoading,
      String? errorMessage});

  @override
  $DailyStatsCopyWith<$Res> get selectedDayStats;
  @override
  $WeeklyStatsCopyWith<$Res> get currentWeekStats;
}

/// @nodoc
class __$$HistoryStateImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryStateImpl>
    implements _$$HistoryStateImplCopyWith<$Res> {
  __$$HistoryStateImplCopyWithImpl(
      _$HistoryStateImpl _value, $Res Function(_$HistoryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? selectedDayStats = null,
    Object? currentWeekStats = null,
    Object? selectedDaySessions = null,
    Object? datesWithActivity = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HistoryStateImpl(
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDayStats: null == selectedDayStats
          ? _value.selectedDayStats
          : selectedDayStats // ignore: cast_nullable_to_non_nullable
              as DailyStats,
      currentWeekStats: null == currentWeekStats
          ? _value.currentWeekStats
          : currentWeekStats // ignore: cast_nullable_to_non_nullable
              as WeeklyStats,
      selectedDaySessions: null == selectedDaySessions
          ? _value._selectedDaySessions
          : selectedDaySessions // ignore: cast_nullable_to_non_nullable
              as List<FocusSession>,
      datesWithActivity: null == datesWithActivity
          ? _value._datesWithActivity
          : datesWithActivity // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HistoryStateImpl extends _HistoryState {
  const _$HistoryStateImpl(
      {required this.selectedDate,
      required this.selectedDayStats,
      required this.currentWeekStats,
      final List<FocusSession> selectedDaySessions = const [],
      final Set<String> datesWithActivity = const {},
      this.isLoading = false,
      this.errorMessage})
      : _selectedDaySessions = selectedDaySessions,
        _datesWithActivity = datesWithActivity,
        super._();

  /// Currently selected date
  @override
  final DateTime selectedDate;

  /// Stats for the selected date
  @override
  final DailyStats selectedDayStats;

  /// Stats for the current week
  @override
  final WeeklyStats currentWeekStats;

  /// Sessions for the selected date
  final List<FocusSession> _selectedDaySessions;

  /// Sessions for the selected date
  @override
  @JsonKey()
  List<FocusSession> get selectedDaySessions {
    if (_selectedDaySessions is EqualUnmodifiableListView)
      return _selectedDaySessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedDaySessions);
  }

  /// Dates that have activity (for calendar markers)
  final Set<String> _datesWithActivity;

  /// Dates that have activity (for calendar markers)
  @override
  @JsonKey()
  Set<String> get datesWithActivity {
    if (_datesWithActivity is EqualUnmodifiableSetView)
      return _datesWithActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_datesWithActivity);
  }

  /// Whether the state is loading
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message if something went wrong
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HistoryState(selectedDate: $selectedDate, selectedDayStats: $selectedDayStats, currentWeekStats: $currentWeekStats, selectedDaySessions: $selectedDaySessions, datesWithActivity: $datesWithActivity, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryStateImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedDayStats, selectedDayStats) ||
                other.selectedDayStats == selectedDayStats) &&
            (identical(other.currentWeekStats, currentWeekStats) ||
                other.currentWeekStats == currentWeekStats) &&
            const DeepCollectionEquality()
                .equals(other._selectedDaySessions, _selectedDaySessions) &&
            const DeepCollectionEquality()
                .equals(other._datesWithActivity, _datesWithActivity) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedDate,
      selectedDayStats,
      currentWeekStats,
      const DeepCollectionEquality().hash(_selectedDaySessions),
      const DeepCollectionEquality().hash(_datesWithActivity),
      isLoading,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      __$$HistoryStateImplCopyWithImpl<_$HistoryStateImpl>(this, _$identity);
}

abstract class _HistoryState extends HistoryState {
  const factory _HistoryState(
      {required final DateTime selectedDate,
      required final DailyStats selectedDayStats,
      required final WeeklyStats currentWeekStats,
      final List<FocusSession> selectedDaySessions,
      final Set<String> datesWithActivity,
      final bool isLoading,
      final String? errorMessage}) = _$HistoryStateImpl;
  const _HistoryState._() : super._();

  @override

  /// Currently selected date
  DateTime get selectedDate;
  @override

  /// Stats for the selected date
  DailyStats get selectedDayStats;
  @override

  /// Stats for the current week
  WeeklyStats get currentWeekStats;
  @override

  /// Sessions for the selected date
  List<FocusSession> get selectedDaySessions;
  @override

  /// Dates that have activity (for calendar markers)
  Set<String> get datesWithActivity;
  @override

  /// Whether the state is loading
  bool get isLoading;
  @override

  /// Error message if something went wrong
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
