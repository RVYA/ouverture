import 'package:flutter/foundation.dart' show required;

import 'package:equatable/equatable.dart';


class Geofence extends Equatable {
  const Geofence({
    @required this.center,
    @required this.radius,
  })
    : assert(
        radius >= 50 && radius <= 250,
        "Radius must satisfy the constraints; (50m <= R <= 250m)",
      );

  final GeographicCoordinate center;
  /// In meters. Ideally, between 50-250 meters.
  final double radius;

  @override
  List<Object> get props => <Object>[  ];
  // TODO: Write some methods for Geofence operations.
}


class GeographicCoordinate extends Equatable {
  const GeographicCoordinate(this.latitude, this.longitude,)
    : assert(latitude >= -90 && latitude <= 90),
      assert(longitude >= -180 && longitude <= 180);

  ///
  /// latitude is a geographic coordinate that specifies the North–South
  /// position of a point on the Earth's surface. Latitude is an angle which
  /// ranges from 0° at the Equator to 90° (North or South) at the poles
  ///
  final double latitude;
  ///
  /// Longitude is a geographic coordinate that specifies the East–West
  /// position of a point on the Earth's surface. It is an angular measurement,
  /// usually expressed in degrees.
  ///
  final double longitude;

  @override
  List<Object> get props => <Object>[ latitude, longitude ];
}