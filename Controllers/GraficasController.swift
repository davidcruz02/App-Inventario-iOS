//
//  GraficasController.swift
//  AppUDL
//
//  Created by ADMIN on 03/12/25.
//

import Foundation
import CryptoKit

class GraficasController: ObservableObject {
    
    @Published var graficaGeneral: GraficaGeneral?
    
    private let claveKey = "Julio_PrestamoEq"
    
    private func generarToken(mensaje: String) -> String {
        let key = SymmetricKey(data: claveKey.data(using: .utf8)!)
        let data = mensaje.data(using: .utf8)!
        let hash = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hash).base64EncodedString()
    }
    
    func obtenerDatosGenerales(completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(false)
            return
        }
        
        let mensaje = ""
        let token = generarToken(mensaje: mensaje)
        
        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <generarDatosParaGraficas xmlns="http://tempuri.org/">
              <token>\(token)</token>
            </generarDatosParaGraficas>
          </soap:Body>
        </soap:Envelope>
        """
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue("\"http://tempuri.org/generarDatosParaGraficas\"", forHTTPHeaderField: "SOAPAction")
        req.httpBody = soap.data(using: .utf8)
        
        URLSession.shared.dataTask(with: req) { data, _, error in
            if error != nil { completion(false); return }
            
            guard let data = data,
                  let texto = String(data: data, encoding: .utf8) else {
                completion(false)
                return
            }
            
            if let ini = texto.range(of: "<generarDatosParaGraficasResult>"),
               let fin = texto.range(of: "</generarDatosParaGraficasResult>") {
                
                let json = String(texto[ini.upperBound..<fin.lowerBound])
                
                if let datos = json.data(using: .utf8),
                   let dict = try? JSONSerialization.jsonObject(with: datos) as? [String:Int] {
                    
                    let g = GraficaGeneral(
                        prestados: dict["prestados"] ?? 0,
                        disponibles: dict["disponibles"] ?? 0,
                        reparacion: dict["reparacion"] ?? 0,
                        baja: dict["baja"] ?? 0
                    )
                    
                    DispatchQueue.main.async {
                        self.graficaGeneral = g
                        completion(true)
                    }
                    
                    return
                }
            }
            
            completion(false)
        }.resume()
    }
}
