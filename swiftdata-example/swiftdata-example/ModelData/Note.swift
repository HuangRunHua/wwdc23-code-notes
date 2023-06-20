//
//  Note.swift
//  swiftdata-example
//
//  Created by Huang Runhua on 6/11/23.
//

import Foundation
import SwiftData

@Model
class Note {
    var createDate: Date
    var title: String
    var subtitle: String
    var content: String
    
    init(createDate: Date = .now, title: String, subtitle: String, content: String) {
        self.createDate = createDate
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }
}

extension Note {
    static var preview: Note {
        Note(title: "Preserving your app’s model data across launches",
             subtitle: "Describe your model classes to SwiftData using the framework’s macros, and store instances of those models so they exist beyond the app’s runtime.",
             content: "Most apps define a number of custom types that model the data it creates or consumes. For example, a travel app might define classes that represent trips, flights, and booked accommodations. Using SwiftData, you can quickly and efficiently persist that data so it’s available across app launches, and leverage the framework’s integration with SwiftUI to refetch that data and display it onscreen.")
    }
}

enum NoteSchemaV1: VersionedSchema {
    static var versionIdentifier: String? = "noteschemav1"
    
    static var models: [any PersistentModel.Type] {
        [Note.self]
    }
    
    @Model
    class Note {
        var createDate: Date
        var title: String
        var subtitle: String
        var content: String
        
        init(createDate: Date = .now, title: String, subtitle: String, content: String) {
            self.createDate = createDate
            self.title = title
            self.subtitle = subtitle
            self.content = content
        }
    }
}

enum NoteSchemaV2: VersionedSchema {
    static var versionIdentifier: String? = "noteschemav2"
    
    static var models: [any PersistentModel.Type] {
        [Note.self]
    }
    
    @Model
    class Note {
        var createDate: Date
        @Attribute(.unique) var title: String
        var subtitle: String
        var content: String
        
        init(createDate: Date = .now, title: String, subtitle: String, content: String) {
            self.createDate = createDate
            self.title = title
            self.subtitle = subtitle
            self.content = content
        }
    }
}

enum NoteMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        // Provide the ordering of schemas.
        [NoteSchemaV1.self, NoteSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrationV1toV2]
    }
    
    static let migrationV1toV2 = MigrationStage.custom(
        fromVersion: NoteSchemaV1.self,
        toVersion: NoteSchemaV2.self,
        willMigrate: { context in
            let notes = try? context.fetch(FetchDescriptor<NoteSchemaV1.Note>())
            try? context.save()
        }, didMigrate: nil
    )
}


