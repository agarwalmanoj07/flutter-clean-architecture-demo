// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      isLoggedIn: json['isLoggedIn'] as bool,
      authTokens: json['authTokens'] == null
          ? null
          : AuthTokens.fromJson(json['authTokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'isLoggedIn': instance.isLoggedIn,
      'authTokens': instance.authTokens,
    };
