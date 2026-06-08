import Foundation
import CryptoKit

class AgregarEqController {

    private let claveKey = "Julio_PrestamoEq"

    private func generarToken(mensaje: String) -> String {
        let key = SymmetricKey(data: claveKey.data(using: .utf8)!)
        let data = mensaje.data(using: .utf8)!
        let hash = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(hash).base64EncodedString()
    }

    func muestraOpcionesStatus(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/wsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        let token = generarToken(mensaje: "")

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <MuestraOpcionesStatus xmlns="http://tempuri.org/">
              <token>\(token)</token>
            </MuestraOpcionesStatus>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/MuestraOpcionesStatus\"", forHTTPHeaderField: "SOAPAction")
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

            if let inicio = texto.range(of: "<MuestraOpcionesStatusResult>"),
               let fin = texto.range(of: "</MuestraOpcionesStatusResult>") {

                let contenido = String(texto[inicio.upperBound..<fin.lowerBound])

                if let datos = contenido.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: datos) as? [[String: Any]] {

                    completion(.success(json))
                    return
                }
            }

            let err = NSError(
                domain: "AgregarEqController",
                code: -3,
                userInfo: [
                    "respuesta": texto,
                    NSLocalizedDescriptionKey: "Formato inválido"
                ]
            )
            completion(.failure(err))

        }.resume()
    }

    func registrarNuevoEquipo(
        no_equipo: String,
        modelo: String,
        no_serie: String,
        id_status: String,
        correo: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {

        guard let url = URL(string: "http://201.168.154.186/WebServices/awsPrestamoEquipos/webservice1.asmx") else {
            completion(.failure(NSError(domain: "URL inválida", code: -1)))
            return
        }

        let mensaje = "\(no_equipo)\(modelo)\(no_serie)\(id_status)\(correo)"
        let token = generarToken(mensaje: mensaje)

        let soap =
        """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <RegistrarNuevoEquipo xmlns="http://tempuri.org/">
              <no_equipo>\(no_equipo)</no_equipo>
              <modelo>\(modelo)</modelo>
              <no_serie>\(no_serie)</no_serie>
              <id_status>\(id_status)</id_status>
              <correo>\(correo)</correo>
              <token>\(token)</token>
            </RegistrarNuevoEquipo>
          </soap:Body>
        </soap:Envelope>
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\"http://tempuri.org/RegistrarNuevoEquipo\"", forHTTPHeaderField: "SOAPAction")
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

            if let inicio = texto.range(of: "<RegistrarNuevoEquipoResult>"),
               let fin = texto.range(of: "</RegistrarNuevoEquipoResult>") {

                let contenido = String(texto[inicio.upperBound..<fin.lowerBound])

                if let datos = contenido.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: datos) as? [String: Any] {
                    completion(.success(json))
                    return
                }
            }

            let err = NSError(domain: "AgregarEqController", code: -3, userInfo: ["respuesta": texto])
            completion(.failure(err))

        }.resume()
    }
}
