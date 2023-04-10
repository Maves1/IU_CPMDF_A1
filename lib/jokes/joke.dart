import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'joke.freezed.dart';
part 'joke.g.dart';

@freezed
class Joke with _$Joke {
  const factory Joke(
      {required List<String> categories,
      @JsonKey(name: 'created_at') required String createdAt,
      @JsonKey(name: 'icon_url') required String iconUrl,
      required String id,
      @JsonKey(name: 'updated_at') required String updatedAt,
      required String url,
      required String value}) = _Joke;

  factory Joke.fromJson(Map<String, Object?> json) => _$JokeFromJson(json);
}
