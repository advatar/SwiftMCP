import Foundation

/// Whether a session's client was disconnected: set once, read from anywhere.
final class DisconnectMark: @unchecked Sendable {
    private let lock = NSLock()
    private var marked = false

    var isMarked: Bool {
        lock.withLock { marked }
    }

    func mark() {
        lock.withLock { marked = true }
    }
}
