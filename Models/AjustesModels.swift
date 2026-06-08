import Foundation
import SwiftUI

struct EquipoItem: Identifiable {
    let id = UUID()            // requerido por SwiftUI
    let id_equipo: String
    let no_equipo: String
    let id_status: String
}

extension EquipoItem {
    init?(dict: [String: Any]) {
        guard let idEquipo = dict["id_equipo"],
              let noEquipo = dict["no_equipo"],
              let idStatus = dict["id_status"]
        else { return nil }

        self.id_equipo = "\(idEquipo)"
        self.no_equipo = "\(noEquipo)"
        self.id_status = "\(idStatus)"
    }
}
