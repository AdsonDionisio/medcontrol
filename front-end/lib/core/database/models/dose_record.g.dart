// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDoseRecordCollection on Isar {
  IsarCollection<DoseRecord> get doseRecords => this.collection();
}

const DoseRecordSchema = CollectionSchema(
  name: r'DoseRecord',
  id: 9029586081048020273,
  properties: {
    r'medicationId': PropertySchema(
      id: 0,
      name: r'medicationId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(id: 1, name: r'notes', type: IsarType.string),
    r'scheduleId': PropertySchema(
      id: 2,
      name: r'scheduleId',
      type: IsarType.long,
    ),
    r'scheduledFor': PropertySchema(
      id: 3,
      name: r'scheduledFor',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 4, name: r'status', type: IsarType.string),
    r'takenAt': PropertySchema(
      id: 5,
      name: r'takenAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _doseRecordEstimateSize,
  serialize: _doseRecordSerialize,
  deserialize: _doseRecordDeserialize,
  deserializeProp: _doseRecordDeserializeProp,
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

  getId: _doseRecordGetId,
  getLinks: _doseRecordGetLinks,
  attach: _doseRecordAttach,
  version: '3.3.2',
);

int _doseRecordEstimateSize(
  DoseRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _doseRecordSerialize(
  DoseRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.medicationId);
  writer.writeString(offsets[1], object.notes);
  writer.writeLong(offsets[2], object.scheduleId);
  writer.writeDateTime(offsets[3], object.scheduledFor);
  writer.writeString(offsets[4], object.status);
  writer.writeDateTime(offsets[5], object.takenAt);
}

DoseRecord _doseRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DoseRecord();
  object.id = id;
  object.medicationId = reader.readLong(offsets[0]);
  object.notes = reader.readStringOrNull(offsets[1]);
  object.scheduleId = reader.readLongOrNull(offsets[2]);
  object.scheduledFor = reader.readDateTime(offsets[3]);
  object.status = reader.readString(offsets[4]);
  object.takenAt = reader.readDateTimeOrNull(offsets[5]);
  return object;
}

P _doseRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _doseRecordGetId(DoseRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _doseRecordGetLinks(DoseRecord object) {
  return [];
}

void _doseRecordAttach(IsarCollection<dynamic> col, Id id, DoseRecord object) {
  object.id = id;
}

extension DoseRecordQueryWhereSort
    on QueryBuilder<DoseRecord, DoseRecord, QWhere> {
  QueryBuilder<DoseRecord, DoseRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhere> anyMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'medicationId'),
      );
    });
  }
}

extension DoseRecordQueryWhere
    on QueryBuilder<DoseRecord, DoseRecord, QWhereClause> {
  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> medicationIdEqualTo(
    int medicationId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'medicationId',
          value: [medicationId],
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause>
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause>
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> medicationIdLessThan(
    int medicationId, {
    bool include = false,
  }) {
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterWhereClause> medicationIdBetween(
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

extension DoseRecordQueryFilter
    on QueryBuilder<DoseRecord, DoseRecord, QFilterCondition> {
  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  medicationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'medicationId', value: value),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
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

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'scheduleId'),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'scheduleId'),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> scheduleIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduleId', value: value),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduleIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduleIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> scheduleIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduleId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduledForEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduledFor', value: value),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduledForGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduledFor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduledForLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduledFor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  scheduledForBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduledFor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> takenAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'takenAt'),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  takenAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'takenAt'),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> takenAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'takenAt', value: value),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition>
  takenAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'takenAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> takenAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'takenAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterFilterCondition> takenAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'takenAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DoseRecordQueryObject
    on QueryBuilder<DoseRecord, DoseRecord, QFilterCondition> {}

extension DoseRecordQueryLinks
    on QueryBuilder<DoseRecord, DoseRecord, QFilterCondition> {}

extension DoseRecordQuerySortBy
    on QueryBuilder<DoseRecord, DoseRecord, QSortBy> {
  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByScheduledFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledFor', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByScheduledForDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledFor', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByTakenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takenAt', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> sortByTakenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takenAt', Sort.desc);
    });
  }
}

extension DoseRecordQuerySortThenBy
    on QueryBuilder<DoseRecord, DoseRecord, QSortThenBy> {
  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByMedicationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicationId', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByScheduleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleId', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByScheduledFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledFor', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByScheduledForDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledFor', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByTakenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takenAt', Sort.asc);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QAfterSortBy> thenByTakenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'takenAt', Sort.desc);
    });
  }
}

extension DoseRecordQueryWhereDistinct
    on QueryBuilder<DoseRecord, DoseRecord, QDistinct> {
  QueryBuilder<DoseRecord, DoseRecord, QDistinct> distinctByMedicationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicationId');
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QDistinct> distinctByScheduleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleId');
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QDistinct> distinctByScheduledFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledFor');
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DoseRecord, DoseRecord, QDistinct> distinctByTakenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'takenAt');
    });
  }
}

extension DoseRecordQueryProperty
    on QueryBuilder<DoseRecord, DoseRecord, QQueryProperty> {
  QueryBuilder<DoseRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DoseRecord, int, QQueryOperations> medicationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicationId');
    });
  }

  QueryBuilder<DoseRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<DoseRecord, int?, QQueryOperations> scheduleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleId');
    });
  }

  QueryBuilder<DoseRecord, DateTime, QQueryOperations> scheduledForProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledFor');
    });
  }

  QueryBuilder<DoseRecord, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DoseRecord, DateTime?, QQueryOperations> takenAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'takenAt');
    });
  }
}
