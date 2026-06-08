import Foundation
import CryptoKit

class BajaEquiposController: ObservableObject {

    @Published var equipos: [EquipoParaEliminar] = []

    private let claveKey = "Julio_PrestamoEq"

    private func generarToken(mensaje: String) -> String {
        let key = SymmetricKey(data: claveKey.data(using: .utf8)!)
        let data = mensaje.data(using: .utf8)!
        let hash = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hash).base64EncodedString()
    }

    func extraerEqParaEliminacion(nombre: String,
                                  correo: String,
                                  completion: @escaping (Result<[EquipoParaEliminar], Error>) -> Void) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        let mensaje = "\(nombre)\(correo)"
        let token = generarToken(mensaje: mensaje)

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <extraerEqParaEliminacion xmlns="http://tempuri.org/">
              <nom>\(nombre)</nom>
              <email>\(correo)</email>
              <token>\(token)</token>
            </extraerEqParaEliminacion>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/extraerEqParaEliminacion\"", forHTTPHeaderField: "SOAPAction")
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

            if let ini = texto.range(of: "<extraerEqParaEliminacionResult>"),
               let fin = texto.range(of: "</extraerEqParaEliminacionResult>") {

                let jsonTexto = String(texto[ini.upperBound..<fin.lowerBound])

                if let datos = jsonTexto.data(using: .utf8),
                   let lista = try? JSONSerialization.jsonObject(with: datos) as? [[String: Any]] {

                    let equipos: [EquipoParaEliminar] = lista.compactMap { item in
                        guard let id = item["id_equipo"] as? String,
                              let no = item["no_equipo"] as? String,
                              let status = item["id_status"] as? String,
                              let admin = item["id_admin"] as? String,
                              let nombreA = item["nombre_admin"] as? String else {
                            return nil
                        }

                        return EquipoParaEliminar(
                            id_equipo: id,
                            no_equipo: no,
                            id_status: status,
                            id_admin: admin,
                            nombre_admin: nombreA
                        )
                    }

                    DispatchQueue.main.async {
                        self.equipos = equipos
                    }

                    completion(.success(equipos))
                    return
                }
            }

            completion(.failure(NSError(domain: "BajaEquiposController",
                                        code: -3,
                                        userInfo: ["respuesta": texto])))
        }.resume()
    }
    
    
    // ============================================================
    // 🔥 ElimincaciondeEquipo
    // ============================================================
    func eliminarEquipo(id_equipo: String,
                        correo: String,
                        completion: @escaping (Result<String, Error>) -> Void) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        // Token: id_equipo + correo
        let mensaje = "\(id_equipo)\(correo)"
        let token = generarToken(mensaje: mensaje)

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <ElimincaciondeEquipo xmlns="http://tempuri.org/">
              <id_equipo>\(id_equipo)</id_equipo>
              <email>\(correo)</email>
              <token>\(token)</token>
            </ElimincaciondeEquipo>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/ElimincaciondeEquipo\"", forHTTPHeaderField: "SOAPAction")
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

            if let ini = texto.range(of: "<ElimincaciondeEquipoResult>"),
               let fin = texto.range(of: "</ElimincaciondeEquipoResult>") {

                let contenido = String(texto[ini.upperBound..<fin.lowerBound])
                completion(.success(contenido))
                return
            }

            completion(.failure(NSError(domain: "ElimincaciondeEquipo",
                                        code: -3,
                                        userInfo: ["respuesta": texto])))

        }.resume()
    }

    
    
    
}
