//
//  GraficasModel.swift
//  AppUDL
//
//  Created by ADMIN on 03/12/25.
//


import Foundation

struct GraficaGeneral: Identifiable {
    let id = UUID()
    let prestados: Int
    let disponibles: Int
    let reparacion: Int
    let baja: Int
}
