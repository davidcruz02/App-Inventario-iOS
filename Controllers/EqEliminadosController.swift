//
//  EqEliminadosController.swift
//  AppUDL
//
//  Created by ADMIN on 02/12/25.
//

import Foundation
import CryptoKit

class EqEliminadosController: ObservableObject {
    
    @Published var equipos: [EquipoEliminado] = []
    
    private let claveKey = "Julio_PrestamoEq"
    
    private func generarToken(mensaje: String) -> String {
        let key = SymmetricKey(data: claveKey.data(using: .utf8)!)
        let data = mensaje.data(using: .utf8)!
        let hash = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hash).base64EncodedString()
    }
    
    func obtenerEquiposEliminados(completion: @escaping (Result<[EquipoEliminado], Error>) -> Void) {
        
        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }
        
        let mensaje = ""       // como tu backend lo pide
        let token = generarToken(mensaje: mensaje)
        
        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <ObtenerEquiposEliminados xmlns="http://tempuri.org/">
              <token>\(token)</token>
            </ObtenerEquiposEliminados>
          </soap:Body>
        </soap:Envelope>
        """
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue("\"http://tempuri.org/ObtenerEquiposEliminados\"", forHTTPHeaderField: "SOAPAction")
        req.httpBody = soap.data(using: .utf8)
        
        URLSession.shared.dataTask(with: req) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let texto = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Sin datos", code: -2)))
                return
            }
            
            if let ini = texto.range(of: "<ObtenerEquiposEliminadosResult>"),
               let fin = texto.range(of: "</ObtenerEquiposEliminadosResult>") {
                
                let json = String(texto[ini.upperBound..<fin.lowerBound])
                
                if let datos = json.data(using: .utf8),
                   let lista = try? JSONSerialization.jsonObject(with: datos) as? [[String:Any]] {
                    
                    let equipos = lista.compactMap { item -> EquipoEliminado? in
                        guard let id = item["id_equipo"] as? String,
                              let no = item["no_equipo"] as? String,
                              let modelo = item["modelo"] as? String,
                              let serie = item["no_serie"] as? String,
                              let status = item["id_status"] as? String else { return nil }
                        
                        return EquipoEliminado(
                            id_equipo: id,
                            no_equipo: no,
                            modelo: modelo,
                            no_serie: serie,
                            id_status: status
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.equipos = equipos
                    }
                    
                    completion(.success(equipos))
                    return
                }
            }
            
            completion(.failure(
                NSError(domain: "EqEliminadosController", code: -3, userInfo: ["respuesta": texto])
            ))
            
        }.resume()
    }
    
    
    // ============================================================
    // 🔥 ObtenerDatosEquipoEliminado
    // ============================================================
    func obtenerDatosEquipoEliminado(id_equipo: String,
                                     completion: @escaping (Result<[String:String], Error>) -> Void) {
        
        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }
        
        let mensaje = "\(id_equipo)"
        let token = generarToken(mensaje: mensaje)
        
        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <ObtenerDatosEquipoEliminado xmlns="http://tempuri.org/">
              <id_equipo>\(id_equipo)</id_equipo>
              <token>\(token)</token>
            </ObtenerDatosEquipoEliminado>
          </soap:Body>
        </soap:Envelope>
        """
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue("\"http://tempuri.org/ObtenerDatosEquipoEliminado\"", forHTTPHeaderField: "SOAPAction")
        req.httpBody = soap.data(using: .utf8)
        
        URLSession.shared.dataTask(with: req) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let texto = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "Sin datos", code: -2)))
                return
            }
            
            if let ini = texto.range(of: "<ObtenerDatosEquipoEliminadoResult>"),
               let fin = texto.range(of: "</ObtenerDatosEquipoEliminadoResult>") {
                
                let json = String(texto[ini.upperBound..<fin.lowerBound])
                
                if let datos = json.data(using: .utf8),
                   let dict = try? JSONSerialization.jsonObject(with: datos) as? [String:String] {
                    
                    completion(.success(dict))
                    return
                }
            }
            
            completion(.failure(
                NSError(domain: "ObtenerDatosEquipoEliminado",
                        code: -3,
                        userInfo: ["respuesta": texto])
            ))
            
        }.resume()
    }

    
    
    
}
