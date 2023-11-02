// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgencyModelAdapter extends TypeAdapter<AgencyModel> {
  @override
  final int typeId = 3;

  @override
  AgencyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgencyModel(
      id: fields[0] as String?,
      createdAt: fields[1] as DateTime?,
      updatedAt: fields[2] as DateTime?,
      countryId: fields[3] as int?,
      name: fields[4] as String?,
      phoneNumber: fields[5] as String?,
      email: fields[6] as String?,
      legalReferences: fields[7] as String?,
      cities: fields[8] as String?,
      description: fields[9] as String?,
      address: fields[10] as String?,
      longitude: fields[11] as String?,
      latitude: fields[12] as String?,
      isBlocked: fields[13] as bool?,
      isDeleted: fields[15] as bool?,
      isVerified: fields[14] as bool?,
      createdBy: fields[16] as String?,
      coverImageUrl: fields[17] as String?,
      profileImageUrl: fields[18] as String?,
      website: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AgencyModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.countryId)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.legalReferences)
      ..writeByte(8)
      ..write(obj.cities)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.longitude)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.isBlocked)
      ..writeByte(14)
      ..write(obj.isVerified)
      ..writeByte(15)
      ..write(obj.isDeleted)
      ..writeByte(16)
      ..write(obj.createdBy)
      ..writeByte(17)
      ..write(obj.coverImageUrl)
      ..writeByte(18)
      ..write(obj.profileImageUrl)
      ..writeByte(19)
      ..write(obj.website);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgencyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
