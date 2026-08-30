/// Represents the geographical coordinates of an address.
class Geo {
  final String lat;
  final String lng;

  const Geo({
    required this.lat,
    required this.lng,
  });

  factory Geo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Geo(lat: '0.0', lng: '0.0');
    }
    return Geo(
      lat: json['lat']?.toString() ?? '0.0',
      lng: json['lng']?.toString() ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

/// Represents the address of a user.
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Address(
        street: 'N/A',
        suite: '',
        city: 'N/A',
        zipcode: 'N/A',
        geo: Geo(lat: '0.0', lng: '0.0'),
      );
    }
    return Address(
      street: json['street'] as String? ?? 'N/A',
      suite: json['suite'] as String? ?? '',
      city: json['city'] as String? ?? 'N/A',
      zipcode: json['zipcode'] as String? ?? 'N/A',
      geo: Geo.fromJson(json['geo'] as Map<String, dynamic>?),
    );
  }

  /// Formatted multi-line or single-line address for display.
  String get fullAddress {
    final parts = [
      if (suite.isNotEmpty) suite,
      if (street.isNotEmpty && street != 'N/A') street,
      if (city.isNotEmpty && city != 'N/A') city,
      if (zipcode.isNotEmpty && zipcode != 'N/A') zipcode,
    ];
    return parts.isEmpty ? 'No address provided' : parts.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo.toJson(),
    };
  }
}

/// Represents the company a user is affiliated with.
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const Company(name: 'N/A', catchPhrase: '', bs: '');
    }
    return Company(
      name: json['name'] as String? ?? 'N/A',
      catchPhrase: json['catchPhrase'] as String? ?? '',
      bs: json['bs'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'catchPhrase': catchPhrase,
      'bs': bs,
    };
  }
}

/// Represents a User fetched from the REST API.
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Address address;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown User',
      username: json['username'] as String? ?? 'anonymous',
      email: json['email'] as String? ?? 'no-email@example.com',
      phone: json['phone'] as String? ?? 'N/A',
      website: json['website'] as String? ?? 'N/A',
      address: Address.fromJson(json['address'] as Map<String, dynamic>?),
      company: Company.fromJson(json['company'] as Map<String, dynamic>?),
    );
  }

  /// Derives 1 or 2 letter initials from the user's name for avatar rendering.
  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address.toJson(),
      'company': company.toJson(),
    };
  }
}
