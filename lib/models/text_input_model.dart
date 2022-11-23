// ignore_for_file: public_member_api_docs, sort_constructors_first
class TextInputModel {
  final bool valid;
  final String? error;
  const TextInputModel({
    this.valid = false,
    this.error,
  });

  @override
  String toString() => 'TextInputModel(valid: $valid, error: $error)';
}
