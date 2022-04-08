import os.log
import Foundation

extension OSLog {
    private static let netwokring: String = "me.tmbr.westdayever.networking"
    public static let request = OSLog(subsystem: OSLog.netwokring, category: "request")
}
