import Foundation
import CryptoKit

class AjustesController {
    
    private let claveKey = "Julio_PrestamoEq"

    private func generarToken(mensaje: String) -> String {
        let key = SymmetricKey(data: claveKey.data(using: .utf8)!)
        let data = mensaje.data(using: .utf8)!
        let hash = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hash).base64EncodedString()
    }

    // ============================================================
    //     🔥  ObtenerEquiposConfiguracion  (lista de equipos)
    // ============================================================
    func obtenerEquiposConfiguracion(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        let token = generarToken(mensaje: "")  // el WS así lo usa

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <obtenerEquiposConfiguracion xmlns="http://tempuri.org/">
              <token>\(token)</token>
            </obtenerEquiposConfiguracion>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/obtenerEquiposConfiguracion\"", forHTTPHeaderField: "SOAPAction")
        request.httpBody = soap.data(using: .utf8)

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

            // extraer la respuesta JSON dentro del nodo SOAP
            if let ini = texto.range(of: "<obtenerEquiposConfiguracionResult>"),
               let fin = texto.range(of: "</obtenerEquiposConfiguracionResult>") {

                let jsonTexto = String(texto[ini.upperBound..<fin.lowerBound])

                if let datos = jsonTexto.data(using: .utf8),
                   let lista = try? JSONSerialization.jsonObject(with: datos) as? [[String: Any]] {

                    completion(.success(lista))
                    return
                }
            }

            let err = NSError(domain: "AjustesController", code: -3, userInfo: ["respuesta": texto])
            completion(.failure(err))

        }.resume()
    }
    
    
    // ============================================================
    //     🔥  ObtenerDatosEquipoCompleto  (datos individuales)
    // ============================================================
    func obtenerDatosEquipoCompleto(id_equipo: String,
                                    completion: @escaping (Result<[String: Any], Error>) -> Void) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        let token = generarToken(mensaje: id_equipo)

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <obtenerDatosEquipoCompleto xmlns="http://tempuri.org/">
              <id_equipo>\(id_equipo)</id_equipo>
              <token>\(token)</token>
            </obtenerDatosEquipoCompleto>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/obtenerDatosEquipoCompleto\"", forHTTPHeaderField: "SOAPAction")
        request.httpBody = soap.data(using: .utf8)

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

            // Buscar nodo SOAP de respuesta
            if let ini = texto.range(of: "<obtenerDatosEquipoCompletoResult>"),
               let fin = texto.range(of: "</obtenerDatosEquipoCompletoResult>") {

                let contenido = String(texto[ini.upperBound..<fin.lowerBound])

                if let datos = contenido.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: datos) as? [String: Any] {

                    completion(.success(json))
                    return
                }
            }

            completion(.failure(NSError(domain: "AjustesController",
                                        code: -3,
                                        userInfo: ["respuesta": texto])))
        }
        .resume()
    }

    // ============================================================
    //     🔥  Actualizar datos de equipo
    // ============================================================
    func actualizarInformaciondelEquipo(
        id_equipo: String,
        no_equipo: String,
        modelo: String,
        no_serie: String,
        id_status: String,
        correo: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        let mensaje = "\(id_equipo)\(no_equipo)\(modelo)\(no_serie)\(id_status)\(correo)"
        let token = generarToken(mensaje: mensaje)

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <ActualizarInformaciondelEquipo xmlns="http://tempuri.org/">
              <id_equipo>\(id_equipo)</id_equipo>
              <no_equipo>\(no_equipo)</no_equipo>
              <modelo>\(modelo)</modelo>
              <no_serie>\(no_serie)</no_serie>
              <id_status>\(id_status)</id_status>
              <correo>\(correo)</correo>
              <token>\(token)</token>
            </ActualizarInformaciondelEquipo>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/ActualizarInformaciondelEquipo\"", forHTTPHeaderField: "SOAPAction")
        request.httpBody = soap.data(using: .utf8)

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

            if let inicio = texto.range(of: "<ActualizarInformaciondelEquipoResult>"),
               let fin = texto.range(of: "</ActualizarInformaciondelEquipoResult>") {

                let contenido = String(texto[inicio.upperBound..<fin.lowerBound])
                completion(.success(contenido))
                return
            }

            let err = NSError(domain: "AjustesController", code: -3, userInfo: ["respuesta": texto])
            completion(.failure(err))

        }.resume()
    }

    // ============================================================
    //     🔥  Mostrar datos especificos de Equipo
    // ============================================================
    
    func obtenerHistorialEquipo(id_equipo: String,
                                completion: @escaping (Result<[[String: Any]], Error>) -> Void) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        // 🔥 El token se genera SOLO con id_equipo
        let mensaje = "\(id_equipo)"
        let token = generarToken(mensaje: mensaje)

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <ObtenerHistorialEquipo xmlns="http://tempuri.org/">
              <id_equipo>\(id_equipo)</id_equipo>
              <token>\(token)</token>
            </ObtenerHistorialEquipo>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/ObtenerHistorialEquipo\"", forHTTPHeaderField: "SOAPAction")
        request.httpBody = soap.data(using: .utf8)

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

            // 🔎 Buscar el nodo correcto
            if let ini = texto.range(of: "<ObtenerHistorialEquipoResult>"),
               let fin = texto.range(of: "</ObtenerHistorialEquipoResult>") {

                let jsonTexto = String(texto[ini.upperBound..<fin.lowerBound])

                if let datos = jsonTexto.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: datos) as? [[String: Any]] {

                    completion(.success(json))
                    return
                }
            }

            let err = NSError(domain: "AjustesController", code: -3, userInfo: ["respuesta": texto])
            completion(.failure(err))

        }.resume()
    }

    
    
}
