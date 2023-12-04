//
//  TempPersistanceHelper.swift
//  Data Persistence Helper
//
//  Created by Abhishek Biswas on 30/11/23.
//

import Foundation
import SQLite3

public enum DatabaseError: Error {
    case invalidDatabaseName
    case databaseCreationFailed(String)
    case tableCreationFailed(String)
}

public enum QueryResult {
    case success
    case failure(Error)
    case rows([[String: Any]])
}

public enum PersistenceError: Error {
    case queryExecutionFailed(String)
    case queryPreparationFailed(String)
}


public class PersistenceHelper {
    private var db: OpaquePointer?
    private let dbName: String
    private let createTableQuery: String
    
    public init(dbName: String, createTableQuery: String) throws {
        self.dbName = dbName
        self.createTableQuery = createTableQuery
        db = try openDatabase()
        try createTableWithSQLQuery(withQueryString: createTableQuery)
    }
    
    private func openDatabase() throws -> OpaquePointer? {
        let fileUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        print("DB_PATH: \(fileUrl.absoluteString)")
        var localScopedDB: OpaquePointer? = nil
        if sqlite3_open(fileUrl.path, &localScopedDB) != SQLITE_OK {
            throw DatabaseError.databaseCreationFailed("Unable to open database at \(dbName)")
        }
        return localScopedDB
    }
    
    public func createTableWithSQLQuery(withQueryString queryString: String) throws {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) != SQLITE_DONE {
                throw DatabaseError.tableCreationFailed("Unable to create table.")
            }
        } else {
            throw DatabaseError.tableCreationFailed("Unable to prepare table creation statement.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    public func executeQuery(_ query: String) -> QueryResult {
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            return .failure(PersistenceError.queryPreparationFailed("Failed to prepare query: \(query), Error: \(errmsg)"))
        }

        var rows = [[String: Any]]()
        while sqlite3_step(statement) == SQLITE_ROW {
            rows.append(rowDictionary(statement: statement))
        }

        sqlite3_finalize(statement)

        if query.lowercased().starts(with: "select") {
            return .rows(rows)
        } else {
            return .success
        }
    }

    private func rowDictionary(statement: OpaquePointer?) -> [String: Any] {
        var row = [String: Any]()
        for index in 0..<sqlite3_column_count(statement) {
            let columnName = String(cString: sqlite3_column_name(statement, index))
            row[columnName] = columnValue(statement: statement, index: index)
        }
        return row
    }

    private func columnValue(statement: OpaquePointer?, index: Int32) -> Any {
        switch sqlite3_column_type(statement, index) {
        case SQLITE_INTEGER:
            return Int(sqlite3_column_int(statement, index))
        case SQLITE_FLOAT:
            return Double(sqlite3_column_double(statement, index))
        case SQLITE_TEXT:
            return String(cString: sqlite3_column_text(statement, index))
        case SQLITE_BLOB:
            return Data(bytes: sqlite3_column_blob(statement, index), count: Int(sqlite3_column_bytes(statement, index)))
        case SQLITE_NULL:
            return NSNull()
        default:
            return NSNull()
        }
    }
}




