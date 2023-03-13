//
//  AuthService.swift
//  TruliooAssignment
//
//  Created by Roni Leshes on 12/03/2023.
//

import Foundation

protocol AuthWorker{
    func login(username: String, password: String) throws
    func register(username: String, password: String) throws
}

class AuthService: AuthProvider{
    let worker: AuthWorker
    init(worker: AuthWorker){
        self.worker = worker
    }
    
    func login(username: String, password: String) -> String? {
        do{
            try self.worker.login(username: username, password: password)
        }catch{
            return error.localizedDescription
        }
        return nil
    }
    
    func register(username: String, password: String) -> String? {
        do{
            try self.worker.register(username: username, password: password)
        }catch{
            return error.localizedDescription
        }
        return nil
    }    
}
