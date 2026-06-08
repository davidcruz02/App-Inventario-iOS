//
//  LoginController.swift
//  App UDL
//
//  Created by ADMIN on 28/10/25.
//

import Foundation
import CryptoKit

class LoginController {
    
    private let claveKey = "Julio_PrestamoEq"
    
    func generarToken(mensaje: String) -> String {
        let key = SymmetricKey(data: claveKey.data(using: .utf8)!)
        let data = mensaje.data(using: .utf8)!
        let hash = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hash).base64EncodedString()
    }
    
    func guardarUsuario(_ usuario: Usuario) {
        if let data = try? JSONEncoder().encode(usuario) {
            UserDefaults.standard.set(data, forKey: "usuarioActivo")
        }
    }
    
    func obtenerUsuario() -> Usuario? {
        if let data = UserDefaults.standard.data(forKey: "usuarioActivo"),
           let usuario = try? JSONDecoder().decode(Usuario.self, from: data) {
            return usuario
        }
        return nil
    }
    
    func cerrarSesion() {
        UserDefaults.standard.removeObject(forKey: "usuarioActivo")
    }
    
    func enviarDatosUsuario(usuario: Usuario, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }
        
        let mensaje = "\(usuario.nombre)\(usuario.correo)\(usuario.imagenURL)true"
        let token = generarToken(mensaje: mensaje)
        
        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <ObtenerDatosUsuario xmlns="http://tempuri.org/">
              <Nombre>\(usuario.nombre)</Nombre>
              <Correo>\(usuario.correo)</Correo>
              <ImagenUrl>\(usuario.imagenURL)</ImagenUrl>
              <UsuarioAutenticado>true</UsuarioAutenticado>
              <token>\(token)</token>
            </ObtenerDatosUsuario>
          </soap:Body>
        </soap:Envelope>
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/ObtenerDatosUsuario\"", forHTTPHeaderField: "SOAPAction")
        request.httpBody = soap.data(using: .utf8)
        request.timeoutInterval = 25

        print("===== SOAP REQUEST ENVIADO =====")
        print(soap)
        print("================================")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let texto = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Sin datos", code: -2)))
                return
            }
            
            print("===== RESPUESTA DEL ASMX =====")
            print(texto)
            print("================================")
            
            // HTML = error del servidor
            if texto.contains("<!DOCTYPE html>") {
                let err = NSError(
                    domain: "ASMX",
                    code: -4,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Error interno en el WebService (HTML)",
                        "respuesta": texto
                    ]
                )
                completion(.failure(err))
                return
            }
            
            // ----------- EXTRACCIÓN CORRECTA DEL JSON -----------
            
            if let inicio = texto.range(of: "<ObtenerDatosUsuarioResult>"),
               let fin = texto.range(of: "</ObtenerDatosUsuarioResult>") {
                
                let contenido = String(texto[inicio.upperBound ..< fin.lowerBound])
                
                if let datos = contenido.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: datos) as? [String: Any] {
                    completion(.success(json))
                    return
                }
            }
            
            // -----------------------------------------------------
            
            let err = NSError(
                domain: "LoginController",
                code: -3,
                userInfo: [
                    "respuesta": texto,
                    NSLocalizedDescriptionKey: "Formato inválido"
                ]
            )
            completion(.failure(err))
            
        }.resume()
    }




}
