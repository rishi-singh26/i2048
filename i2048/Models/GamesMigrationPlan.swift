//
//  GamesMigrationPlan.swift
//  i2048
//
//  Created by Rishi Singh on 24/12/24.
//

import Foundation
import SwiftData

enum GamesMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [GameSchemaV1.self, GameSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: GameSchemaV1.self,
        toVersion: GameSchemaV2.self
    )
}
