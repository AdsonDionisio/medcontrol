// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_measurement.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHealthMeasurementCollection on Isar {
  IsarCollection<HealthMeasurement> get healthMeasurements => this.collection();
}

const HealthMeasurementSchema = CollectionSchema(
  name: r'HealthMeasurement',
  id: 2233713779022513207,
  properties: {
    r'measuredAt': PropertySchema(
      id: 0,
      name: r'measuredAt',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(id: 1, name: r'notes', type: IsarType.string),
    r'primaryValue': PropertySchema(
      id: 2,
      name: r'primaryValue',
      type: IsarType.double,
    ),
    r'secondaryValue': PropertySchema(
      id: 3,
      name: r'secondaryValue',
      type: IsarType.double,
    ),
    r'type': PropertySchema(id: 4, name: r'type', type: IsarType.string),
    r'unit': PropertySchema(id: 5, name: r'unit', type: IsarType.string),
  },

  estimateSize: _healthMeasurementEstimateSize,
  serialize: _healthMeasurementSerialize,
  deserialize: _healthMeasurementDeserialize,
  deserializeProp: _healthMeasurementDeserializeProp,
  idName: r'id',
  indexes: {
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.hash,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _healthMeasurementGetId,
  getLinks: _healthMeasurementGetLinks,
  attach: _healthMeasurementAttach,
  version: '3.3.2',
);

int _healthMeasurementEstimateSize(
  HealthMeasurement object,
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
  bytesCount += 3 + object.type.length * 3;
  {
    final value = object.unit;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _healthMeasurementSerialize(
  HealthMeasurement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.measuredAt);
  writer.writeString(offsets[1], object.notes);
  writer.writeDouble(offsets[2], object.primaryValue);
  writer.writeDouble(offsets[3], object.secondaryValue);
  writer.writeString(offsets[4], object.type);
  writer.writeString(offsets[5], object.unit);
}

HealthMeasurement _healthMeasurementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HealthMeasurement();
  object.id = id;
  object.measuredAt = reader.readDateTime(offsets[0]);
  object.notes = reader.readStringOrNull(offsets[1]);
  object.primaryValue = reader.readDouble(offsets[2]);
  object.secondaryValue = reader.readDoubleOrNull(offsets[3]);
  object.type = reader.readString(offsets[4]);
  object.unit = reader.readStringOrNull(offsets[5]);
  return object;
}

P _healthMeasurementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _healthMeasurementGetId(HealthMeasurement object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _healthMeasurementGetLinks(
  HealthMeasurement object,
) {
  return [];
}

void _healthMeasurementAttach(
  IsarCollection<dynamic> col,
  Id id,
  HealthMeasurement object,
) {
  object.id = id;
}

extension HealthMeasurementQueryWhereSort
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QWhere> {
  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HealthMeasurementQueryWhere
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QWhereClause> {
  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
  typeEqualTo(String type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'type', value: [type]),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterWhereClause>
  typeNotEqualTo(String type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension HealthMeasurementQueryFilter
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QFilterCondition> {
  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  measuredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'measuredAt', value: value),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  measuredAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'measuredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  measuredAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'measuredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  measuredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'measuredAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesGreaterThan(
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesLessThan(
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesBetween(
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  primaryValueEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'primaryValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  primaryValueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'primaryValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  primaryValueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'primaryValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  primaryValueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'primaryValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  secondaryValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'secondaryValue'),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  secondaryValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'secondaryValue'),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  secondaryValueEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'secondaryValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  secondaryValueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'secondaryValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  secondaryValueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'secondaryValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  secondaryValueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'secondaryValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'unit'),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'unit'),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'unit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'unit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unit', value: ''),
      );
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterFilterCondition>
  unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'unit', value: ''),
      );
    });
  }
}

extension HealthMeasurementQueryObject
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QFilterCondition> {}

extension HealthMeasurementQueryLinks
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QFilterCondition> {}

extension HealthMeasurementQuerySortBy
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QSortBy> {
  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByMeasuredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByPrimaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByPrimaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortBySecondaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortBySecondaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension HealthMeasurementQuerySortThenBy
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QSortThenBy> {
  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByMeasuredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByPrimaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByPrimaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenBySecondaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenBySecondaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QAfterSortBy>
  thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension HealthMeasurementQueryWhereDistinct
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct> {
  QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct>
  distinctByMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measuredAt');
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct>
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct>
  distinctByPrimaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryValue');
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct>
  distinctBySecondaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondaryValue');
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthMeasurement, HealthMeasurement, QDistinct> distinctByUnit({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }
}

extension HealthMeasurementQueryProperty
    on QueryBuilder<HealthMeasurement, HealthMeasurement, QQueryProperty> {
  QueryBuilder<HealthMeasurement, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HealthMeasurement, DateTime, QQueryOperations>
  measuredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measuredAt');
    });
  }

  QueryBuilder<HealthMeasurement, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<HealthMeasurement, double, QQueryOperations>
  primaryValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryValue');
    });
  }

  QueryBuilder<HealthMeasurement, double?, QQueryOperations>
  secondaryValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondaryValue');
    });
  }

  QueryBuilder<HealthMeasurement, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<HealthMeasurement, String?, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
