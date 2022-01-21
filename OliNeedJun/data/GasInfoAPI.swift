//
//  GasInfoAPI.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/21.
//

import Foundation
import Moya
public enum GasInfoAPI{
    case getGasAverage
}

extension GasInfoAPI: TargetType, AccessTokenAuthorizable {
    
    public var baseURL: URL { URL(string: "https://www.opinet.co.kr/api/aroundAll.do?code=&x=375335.4&y=127146&radius=5000&sort=2&prodcd=B027")! }
    
    public var path: String {
        let servicePath = "/2020-flo"
        switch self {
        case .getGasAverage:
            return servicePath + "&out=json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getGasAverage:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getGasAverage:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var authorizationType: AuthorizationType? {
        return .none
    }
    
}
