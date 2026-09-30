#if Server && canImport(Network)
import Network
import Testing
@testable import SwiftMCP

@Suite("TCP explicit loopback binding", .serialized)
struct TCPLoopbackBindingTests {
    @Test("Both local scopes constrain interface and destination address",
          arguments: [DiscoveryScope.localUser, .localMachine], [true, false])
    func localScopeBinding(scope: DiscoveryScope, preferIPv4: Bool) throws {
        for port: UInt16? in [nil, 51000] {
            let transport = TCPBonjourTransport(instanceName: "loopback-test", scope: scope,
                                                 port: port, preferIPv4: preferIPv4)
            let listener = try transport.createListener()
            defer { listener.cancel() }
            #expect(listener.parameters.requiredInterfaceType == .loopback)
            guard case let .hostPort(host, boundPort) = listener.parameters.requiredLocalEndpoint else {
                Issue.record("Local scope did not bind an explicit loopback address")
                return
            }
            #expect(host == NWEndpoint.Host(preferIPv4 ? "127.0.0.1" : "::1"))
            #expect(boundPort.rawValue == (port ?? 0))
        }
    }

    @Test("Network scope retains its attached-link behavior")
    func networkScopeBinding() throws {
        let transport = TCPBonjourTransport(instanceName: "network-test", scope: .localNetwork)
        let listener = try transport.createListener()
        defer { listener.cancel() }
        #expect(listener.parameters.requiredLocalEndpoint == nil)
        #expect(listener.parameters.acceptLocalOnly)
    }
}
#endif
