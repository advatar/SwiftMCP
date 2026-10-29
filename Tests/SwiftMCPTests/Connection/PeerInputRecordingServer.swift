#if Server && canImport(Network)
import Foundation
@testable import SwiftMCP

final class PeerInputRecordingServer: MCPServer, @unchecked Sendable {
    let inner: any MCPServer
    private let lock = NSLock()
    private var recorded: Session?
    var session: Session? { lock.withLock { recorded } }
    init(wrapping inner: any MCPServer) { self.inner = inner }
    func handleMessage(_ message: JSONRPCMessage) async -> JSONRPCMessage? {
        lock.withLock { recorded = Session.current }
        return await inner.handleMessage(message)
    }
}
#endif
