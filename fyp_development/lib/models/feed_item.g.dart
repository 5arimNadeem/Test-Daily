// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedItemAdapter extends TypeAdapter<FeedItem> {
  @override
  final int typeId = 0;

  @override
  FeedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedItem(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String?,
      source: fields[4] as String,
      category: fields[5] as String,
      date: fields[6] as DateTime,
      content: fields[7] as String,
      externalUrl: fields[8] as String?,
      // fields 9-11 may be absent in data written by v1 — default gracefully
      type: fields[9] as String? ?? 'article',
      videoId: fields[10] as String?,
      duration: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FeedItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.content)
      ..writeByte(8)
      ..write(obj.externalUrl)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.videoId)
      ..writeByte(11)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
