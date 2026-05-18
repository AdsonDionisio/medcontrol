// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_schedule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMedicationScheduleCollection on Isar {
  IsarCollection<MedicationSchedule> get medicationSchedules =>
      this.collection();
}

const MedicationScheduleSchema = CollectionSchema(
  name: r'MedicationSchedule',
  id: 5561357715628435963,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'intervalDays': PropertySchema(
      id: 1,
      name: r'intervalDays',
      type: IsarType.long,
    ),
    r'medicationId': PropertySchema(
      id: 2,
      name: r'medicationId',
      type: IsarType.long,
    ),
    r'notificationsEnabled': PropertySchema(
      id: 3,
      name: r'notificationsEnabled',
      type: IsarType.bool,
    ),
    r'recurrence': PropertySchema(
      id: 4,
      name: r'recurrence',
      type: IsarType.string,
    ),
    r'timeLabel': PropertySchema(
      id: 5,
      name: r'timeLabel',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _medicationScheduleEstimateSize,
  serialize: _medicationScheduleSerialize,
  deserialize: _medicationScheduleDeserialize,
  deserializeProp: _medicationScheduleDeserializeProp,
  idName: r'id',
  indexes: {
    r'medicationId': IndexSchema(
      id: -3054361819135306882,
      name: r'medicationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'medicationId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _medicationScheduleGetId,
  getLinks: _medicationScheduleGetLinks,
  attach: _medicationScheduleAttach,
  version: '3.3.2',
);

int _medicationScheduleEstimateSize(
  MedicationSchedule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.recurrence.length * 3;
  bytesCount += 3 + object.timeLabel.length * 3;
  return bytesCount;
}

void _medicationScheduleSerialize(
  MedicationSchedule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.intervalDays);
  writer.writeLong(offsets[2], object.medicationId);
  writer.writeBool(offsets[3], object.notificationsEnabled);
  writer.writeString(offsets[4], object.recurrence);
  writer.writeString(offsets[5], object.timeLabel);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

MedicationSchedule _medicationScheduleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicationSchedule();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.intervalDays = reader.readLong(offsets[1]);
  object.medicationId = reader.readLong(offsets[2]);
  object.notificationsEnabled = reader.readBool(offsets[3]);
  object.recurrence = reader.readString(offsets[4]);
  object.timeLabel = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _medicationScheduleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _medicationScheduleGetId(MedicationSchedule object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _medicationScheduleGetLinks(
  MedicationSchedule object,
) {
  return [];
}

void _medicationScheduleAttach(
  IsarCollection<dynamic> col,
  Id id,
  MedicationSchedule object,
) {
  object.id = id;
}

extension MedicationScheduleQueryWhereSort
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QWhere> {
  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhere>
  anyMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'medicationId'),
      );
    });
  }
}

extension MedicationScheduleQueryWhere
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QWhereClause> {
  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  medicationIdEqualTo(int medicationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'medicationId',
          value: [medicationId],
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  medicationIdNotEqualTo(int medicationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'medicationId',
                lower: [],
                upper: [medicationId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'medicationId',
                lower: [medicationId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'medicationId',
                lower: [medicationId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'medicationId',
                lower: [],
                upper: [medicationId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  medicationIdGreaterThan(int medicationId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'medicationId',
          lower: [medicationId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  medicationIdLessThan(int medicationId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'medicationId',
          lower: [],
          upper: [medicationId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterWhereClause>
  medicationIdBetween(
    int lowerMedicationId,
    int upperMedicationId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'medicationId',
          lower: [lowerMedicationId],
          includeLower: includeLower,
          upper: [upperMedicationId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MedicationScheduleQueryFilter
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QFilterCondition> {
  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  intervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'intervalDays', value: value),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  intervalDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'intervalDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  intervalDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'intervalDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  intervalDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'intervalDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  medicationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'medicationId', value: value),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  medicationIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'medicationId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  medicationIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'medicationId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  medicationIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'medicationId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  notificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notificationsEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recurrence',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recurrence',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recurrence',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recurrence',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recurrence',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recurrence',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recurrence',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recurrence',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recurrence', value: ''),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  recurrenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recurrence', value: ''),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'timeLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'timeLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'timeLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'timeLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'timeLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeLabel', value: ''),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  timeLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'timeLabel', value: ''),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MedicationScheduleQueryObject
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QFilterCondition> {}

extension MedicationScheduleQueryLinks
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QFilterCondition> {}

extension MedicationScheduleQuerySortBy
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QSortBy> {
  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByRecurrence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByRecurrenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByTimeLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLabel', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByTimeLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLabel', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MedicationScheduleQuerySortThenBy
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QSortThenBy> {
  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByRecurrence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByRecurrenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrence', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByTimeLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLabel', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByTimeLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLabel', Sort.desc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MedicationScheduleQueryWhereDistinct
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct> {
  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalDays');
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicationId');
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationsEnabled');
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByRecurrence({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrence', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByTimeLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MedicationSchedule, MedicationSchedule, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MedicationScheduleQueryProperty
    on QueryBuilder<MedicationSchedule, MedicationSchedule, QQueryProperty> {
  QueryBuilder<MedicationSchedule, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MedicationSchedule, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MedicationSchedule, int, QQueryOperations>
  intervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalDays');
    });
  }

  QueryBuilder<MedicationSchedule, int, QQueryOperations>
  medicationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicationId');
    });
  }

  QueryBuilder<MedicationSchedule, bool, QQueryOperations>
  notificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationsEnabled');
    });
  }

  QueryBuilder<MedicationSchedule, String, QQueryOperations>
  recurrenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrence');
    });
  }

  QueryBuilder<MedicationSchedule, String, QQueryOperations>
  timeLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeLabel');
    });
  }

  QueryBuilder<MedicationSchedule, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
