// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBackupSettingsCollection on Isar {
  IsarCollection<BackupSettings> get backupSettings => this.collection();
}

const BackupSettingsSchema = CollectionSchema(
  name: r'BackupSettings',
  id: -1365936085810524006,
  properties: {
    r'automaticBackupEnabled': PropertySchema(
      id: 0,
      name: r'automaticBackupEnabled',
      type: IsarType.bool,
    ),
    r'backupLocation': PropertySchema(
      id: 1,
      name: r'backupLocation',
      type: IsarType.string,
    ),
    r'frequency': PropertySchema(
      id: 2,
      name: r'frequency',
      type: IsarType.string,
    ),
    r'lastBackupAt': PropertySchema(
      id: 3,
      name: r'lastBackupAt',
      type: IsarType.dateTime,
    ),
    r'lastBackupPath': PropertySchema(
      id: 4,
      name: r'lastBackupPath',
      type: IsarType.string,
    ),
  },

  estimateSize: _backupSettingsEstimateSize,
  serialize: _backupSettingsSerialize,
  deserialize: _backupSettingsDeserialize,
  deserializeProp: _backupSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _backupSettingsGetId,
  getLinks: _backupSettingsGetLinks,
  attach: _backupSettingsAttach,
  version: '3.3.2',
);

int _backupSettingsEstimateSize(
  BackupSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.backupLocation.length * 3;
  bytesCount += 3 + object.frequency.length * 3;
  {
    final value = object.lastBackupPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _backupSettingsSerialize(
  BackupSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.automaticBackupEnabled);
  writer.writeString(offsets[1], object.backupLocation);
  writer.writeString(offsets[2], object.frequency);
  writer.writeDateTime(offsets[3], object.lastBackupAt);
  writer.writeString(offsets[4], object.lastBackupPath);
}

BackupSettings _backupSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BackupSettings(id: id);
  object.automaticBackupEnabled = reader.readBool(offsets[0]);
  object.backupLocation = reader.readString(offsets[1]);
  object.frequency = reader.readString(offsets[2]);
  object.lastBackupAt = reader.readDateTimeOrNull(offsets[3]);
  object.lastBackupPath = reader.readStringOrNull(offsets[4]);
  return object;
}

P _backupSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _backupSettingsGetId(BackupSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _backupSettingsGetLinks(BackupSettings object) {
  return [];
}

void _backupSettingsAttach(
  IsarCollection<dynamic> col,
  Id id,
  BackupSettings object,
) {
  object.id = id;
}

extension BackupSettingsQueryWhereSort
    on QueryBuilder<BackupSettings, BackupSettings, QWhere> {
  QueryBuilder<BackupSettings, BackupSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BackupSettingsQueryWhere
    on QueryBuilder<BackupSettings, BackupSettings, QWhereClause> {
  QueryBuilder<BackupSettings, BackupSettings, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<BackupSettings, BackupSettings, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterWhereClause> idBetween(
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
}

extension BackupSettingsQueryFilter
    on QueryBuilder<BackupSettings, BackupSettings, QFilterCondition> {
  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  automaticBackupEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'automaticBackupEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'backupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'backupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'backupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'backupLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupLocation', value: ''),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  backupLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'backupLocation', value: ''),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'frequency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'frequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'frequency',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequency', value: ''),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  frequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'frequency', value: ''),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
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

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
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

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastBackupAt'),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastBackupAt'),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastBackupAt', value: value),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastBackupAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastBackupAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastBackupAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastBackupPath'),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastBackupPath'),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastBackupPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastBackupPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastBackupPath', value: ''),
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterFilterCondition>
  lastBackupPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastBackupPath', value: ''),
      );
    });
  }
}

extension BackupSettingsQueryObject
    on QueryBuilder<BackupSettings, BackupSettings, QFilterCondition> {}

extension BackupSettingsQueryLinks
    on QueryBuilder<BackupSettings, BackupSettings, QFilterCondition> {}

extension BackupSettingsQuerySortBy
    on QueryBuilder<BackupSettings, BackupSettings, QSortBy> {
  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByAutomaticBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticBackupEnabled', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByAutomaticBackupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticBackupEnabled', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByBackupLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupLocation', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByBackupLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupLocation', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy> sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByLastBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByLastBackupAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByLastBackupPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  sortByLastBackupPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.desc);
    });
  }
}

extension BackupSettingsQuerySortThenBy
    on QueryBuilder<BackupSettings, BackupSettings, QSortThenBy> {
  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByAutomaticBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticBackupEnabled', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByAutomaticBackupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'automaticBackupEnabled', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByBackupLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupLocation', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByBackupLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupLocation', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy> thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByLastBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByLastBackupAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupAt', Sort.desc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByLastBackupPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.asc);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QAfterSortBy>
  thenByLastBackupPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupPath', Sort.desc);
    });
  }
}

extension BackupSettingsQueryWhereDistinct
    on QueryBuilder<BackupSettings, BackupSettings, QDistinct> {
  QueryBuilder<BackupSettings, BackupSettings, QDistinct>
  distinctByAutomaticBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'automaticBackupEnabled');
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QDistinct>
  distinctByBackupLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'backupLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QDistinct> distinctByFrequency({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QDistinct>
  distinctByLastBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBackupAt');
    });
  }

  QueryBuilder<BackupSettings, BackupSettings, QDistinct>
  distinctByLastBackupPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastBackupPath',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension BackupSettingsQueryProperty
    on QueryBuilder<BackupSettings, BackupSettings, QQueryProperty> {
  QueryBuilder<BackupSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BackupSettings, bool, QQueryOperations>
  automaticBackupEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'automaticBackupEnabled');
    });
  }

  QueryBuilder<BackupSettings, String, QQueryOperations>
  backupLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupLocation');
    });
  }

  QueryBuilder<BackupSettings, String, QQueryOperations> frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<BackupSettings, DateTime?, QQueryOperations>
  lastBackupAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackupAt');
    });
  }

  QueryBuilder<BackupSettings, String?, QQueryOperations>
  lastBackupPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackupPath');
    });
  }
}
