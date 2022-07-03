//
//  LoginAndLogoutRequest.swift
//  sevenCleanCode
//
//  Created by Andrey Vensko on 28.06.22.
//

import Foundation

class LoginAndLogoutFactoru {
    let dataModel: EnterModel

    init(_ datamodel: EnterModel) {
        self.dataModel = datamodel
    }

    func param(urlMethod: ConfMethodURL) -> [String: String] {
        switch urlMethod {
        case .login:
            return ["username": dataModel.userName,
                    "password": dataModel.password]
        case .logout:
            return ["id_user": "\(String(describing: dataModel.id))"]
        }
    }
}

class LoginAndLogoutRequest: RequestProtocolEnterExit {
    static func == (lhs: LoginAndLogoutRequest, rhs: LoginAndLogoutRequest) -> Bool {
        return lhs == rhs
    }

    var configureUrl: ConfURLProtocol
    var session: URLSession
    var urlMethod: ConfMethodURL

    init(configUrl: ConfURLProtocol, urlMethod: ConfMethodURL) {
        self.configureUrl = configUrl
        self.session = {
            let config = URLSessionConfiguration.default
            let session = URLSession.init(configuration: config)
            return session
        }()
        self.urlMethod = urlMethod
    }

    func load(data: EnterModel,
              completion: @escaping ((Result<Data, Error>) -> ())) {
        var url: URL
        let param: [String: String] = LoginAndLogoutFactoru(data)
                                            .param(urlMethod: urlMethod)

        do {
            url = try configureUrl.configure(param: param, path: .login)
        } catch {
            completion(.failure(ErrorMyCastom.errorUrlComponent))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(ErrorMyCastom.enterLoginAndPassword))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
