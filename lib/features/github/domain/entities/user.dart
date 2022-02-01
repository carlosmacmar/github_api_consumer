import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String login;
  final int id;
  final String nodeId;
  final String avatarUrl;

  User({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
  });

  @override
  List<Object> get props => [
        login,
        id,
        nodeId,
        avatarUrl,
      ];
}
