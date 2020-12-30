class Role {
  final String apiToken;
  final String company;
  final int subscriptionId;

  Role({this.apiToken, this.company, this.subscriptionId});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        apiToken: json['api_token'],
        company: json['company'],
        subscriptionId: json['subscription_id']);
  }
}
