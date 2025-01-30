abstract class ModelRef {
  final String id;
  final String repr;

  ModelRef({
    required this.id,
    required this.repr,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'repr': repr,
      };
}
