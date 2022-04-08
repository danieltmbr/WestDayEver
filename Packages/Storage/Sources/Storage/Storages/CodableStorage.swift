import Foundation
import Combine
import os

/// This implementation is just a generalisation of CoffeeDataStore from Apple's Coffee Tracker sample project
/// https://developer.apple.com/documentation/clockkit/creating_and_updating_a_complication_s_timeline

public actor CodableStorage<Key, Value, Encoder, Decoder>: Storage
where Key: CustomStringConvertible, Value: Codable, Value: Equatable,
      Encoder: TopLevelEncoder, Encoder.Output == Data,
      Decoder: TopLevelDecoder, Decoder.Input == Data {

    private let logger: Logger
    
    private let encoder: Encoder
    
    private let decoder: Decoder
    
    private let fileManager: FileManager
    
    private let directory: String
    
    private let fileExtension: String
    
    // Used to determine whether there are any changes that can be saved to disk.
    private var savedValue: Value?
    
    public init(
        logger: Logger,
        encoder: Encoder,
        decoder: Decoder,
        fileManager: FileManager,
        directory: String,
        fileExtension: String
    ) {
        self.logger = logger
        self.encoder = encoder
        self.decoder = decoder
        self.fileManager = fileManager
        self.directory = directory
        self.fileExtension = fileExtension
    }
    
    public convenience init(
        logger: Logger = .storage,
        plistEncoder: PropertyListEncoder = .init(),
        plistDecoder: PropertyListDecoder = .init(),
        fileManager: FileManager = .default,
        directory: String
    ) where Encoder == PropertyListEncoder, Decoder == PropertyListDecoder {
        self.init(
            logger: logger,
            encoder: plistEncoder,
            decoder: plistDecoder,
            fileManager: fileManager,
            directory: directory,
            fileExtension: "plist"
        )
    }
    
    public func save(_ value: Value, with key: Key) async throws {
        // Don't save the data if there haven't been any changes.
        if value == savedValue {
            logger.debug("Data hasn't changed. No need to save.")
            return
        }
        
        let data: Data
        do {
            // Encode the currentDrinks array.
            data = try encoder.encode(value)
        } catch {
            logger.error("An error occurred while encoding the data: \(error.localizedDescription)")
            throw error
        }
                
        do {
            // Create folder if needed
            try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true)
            
            // Write the data to disk
            try data.write(to: self.dataURL(for: key), options: [.atomic])
            
            // Update the saved value.
            self.savedValue = value
            
            self.logger.debug("Saved!")
        } catch {
            self.logger.error("An error occurred while saving the data: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func load(with key: Key) async throws -> Value? {
        logger.debug("Loading the \(String(describing: Value.self)).")
        
        let value: Value?
        
        do {
            let data = try Data(contentsOf: self.dataURL(for: key))
            value = try decoder.decode(Value.self, from: data)
            logger.debug("Data loaded from disk")
        } catch CocoaError.fileReadNoSuchFile {
            logger.debug("No file found--creating an empty value list.")
            value = nil
        } catch {
            logger.error("*** An unexpected error occurred while loading data: \(error.localizedDescription) ***")
            throw error
        }
        
        // Update the saved values in memory.
        savedValue = value
        return value
    }
    
    public func clear(with key: Key) async throws {
        Task(priority: .background) {
            try fileManager.removeItem(at: self.dataURL(for: key))
        }
    }

    private var folderUrl: URL {
        get throws {
            try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .appendingPathComponent(directory, isDirectory: true)
        }
    }
    
    private func dataURL(for key: Key) throws -> URL {
        try folderUrl.appendingPathComponent("\(key).\(fileExtension)")
    }
}


