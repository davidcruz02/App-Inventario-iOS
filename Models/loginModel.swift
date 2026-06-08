//
//  loginModel.swift
//  App UDL
//
//  Created by ADMIN on 28/10/25.
//

import Foundation

// Modelo de datos del usuario
struct Usuario: Codable {
    var nombre: String
    var correo: String
    var imagenURL: String
    var idAdmin: Int?
}

// Objeto observable para compartir datos en la app
class UsuarioSesion: ObservableObject {
    @Published var usuario: Usuario? = nil
}
