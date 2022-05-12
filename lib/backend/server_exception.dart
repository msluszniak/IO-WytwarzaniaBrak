class ServerException implements Exception{
  final int responseCode;

  @override
  String toString(){
    return "Error code: $responseCode";
  }

  ServerException({required this.responseCode});
}