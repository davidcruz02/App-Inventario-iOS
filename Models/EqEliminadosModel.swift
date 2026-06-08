//
//  EqEliminadosModel.swift
//  AppUDL
//
//  Created by ADMIN on 02/12/25.
//

import Foundation

struct EquipoEliminado: Identifiable, Hashable {
    let id: String           // mismo que id_equipo
    let no_equipo: String
    let modelo: String
    let no_serie: String
    let id_status: String
    
    init(id_equipo: String, no_equipo: String, modelo: String, no_serie: String, id_status: String) {
        self.id = id_equipo
        self.no_equipo = no_equipo
        self.modelo = modelo
        self.no_serie = no_serie
        self.id_status = id_status
    }
}
