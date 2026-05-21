class Endpoints {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const String users = '/users';
}

class QueryParameters {
  static const String page = 'page';
}

class HeaderParameters {
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}

class HttpMethods {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';
}

class StatusCodes {
  static const int success = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
}

class ResponseKeys {
  static const String data = 'data';
  static const String page = 'page';
  static const String perPage = 'per_page';
  static const String total = 'total';
  static const String totalPages = 'total_pages';
}

class JsonKeys {
  static const String id = 'id';
  static const String email = 'email';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String avatar = 'avatar';
}

class CacheKeys {
  static const String users = 'users';
}

class CacheConstants {
  static const String baseUrl = 'baseUrl';
  static const String token = 'token';
}
