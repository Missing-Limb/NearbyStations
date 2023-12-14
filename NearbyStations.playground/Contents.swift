import Foundation
import CoreLocation
import Collections

struct PreviewStation {
    let name: String
    let location: CLLocation

    init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, name: String) {
        self.name = name
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }

    public func distance(from location: CLLocation) -> CLLocationDistance {
        self.location.distance(from: location)
    }

    public func distance(from station: PreviewStation) -> CLLocationDistance {
        self.location.distance(from: station.location)
    }
}

struct PreviewStations {

    static let mine: PreviewStation =
        .init(40.83643, 14.30637, name: "My Location")

    static let `default`: Deque<PreviewStation> = [
        .init(40.85583, 14.26949, name: "Back In Black - Close to Garibaldi"),
        .init(40.85732, 14.27025, name: "Five Minutes - Via Arenaccia"),
        .init(40.85745, 14.26621, name: "Closer - Vico Crispano"),
        .init(40.86292, 14.27325, name: "Some Minds - Via Colonnello Carlo LaHalle"),
        .init(40.83663, 14.30660, name: "Good in Bed - Academy")
    ]
}

print(PreviewStations.default)

for location in PreviewStations.default.sorted(by: { lhs, rhs in
    return (
        lhs.distance(from: PreviewStations.mine) <
            rhs.distance(from: PreviewStations.mine)
    )
}) {
    print(location.name, location.distance(from: PreviewStations.mine))
}
