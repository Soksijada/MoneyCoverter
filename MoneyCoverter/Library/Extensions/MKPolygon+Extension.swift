//
//  MKPolygon+Extension.swift
//  Geofencing
//
//  Created by Krešimir Baković on 25/03/2020.
//  Copyright © 2020 Codable Studio. All rights reserved.
//

import Foundation
import MapKit

extension MKPolygon {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint: MKMapPoint = MKMapPoint(coordinate)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)
        if polygonRenderer.path == nil {
          return false
        } else {
          return polygonRenderer.path.contains(polygonViewPoint)
        }
    }
}
