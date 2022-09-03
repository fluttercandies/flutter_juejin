// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repositories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAuthenAdapter extends TypeAdapter<UserAuthen> {
  @override
  final int typeId = 1;

  @override
  UserAuthen read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAuthen(
      token: fields[0] as String,
      refreshToken: fields[1] as String,
      expireIn: fields[2] as int,
      timestamp: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserAuthen obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.expireIn)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
