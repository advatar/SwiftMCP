# Observation connection lifecycle — BrIAn #692

Tracked by https://github.com/advatar/BrIAn/issues/692 (fork issues are disabled).

- [x] Reproduce observation context remaining live during TCP clean-EOF draining at 351fe256.
- [x] Expose transport-owned peer-input closure without changing ordinary half-close reply semantics.
- [x] 55 TCP/HTTP disconnect, teardown, failure, session and send-stall tests passed on macOS at swift-log 1.10.1 (bbd81b6725ae874c69e9b8c8804d462356b55523), JSONFoundation 3.2.1 (faceccfb9c72c9ba7c872053fc7cf479c1dc1a76).
- [x] Prepare draft dependency for BrIAn #692; no merge or production enablement.

# MobileMCP loopback binding patch

Tracked by https://github.com/advatar/BrIAn/issues/361 (fork issues are disabled).

- [x] Reproduce the localUser wildcard socket accepting a same-host LAN-address connection.
- [x] Require an explicit loopback local endpoint as well as the loopback interface.
- [x] Cover both local scopes, IPv4/IPv6 selection, and fixed/ephemeral ports.
- [x] Run focused transport tests and publish the immutable patch for MobileMCP.

The interface constraint already restricts paths; a same-host LAN-address connection
is not proof of access from another machine. Explicit address binding removes that
ambiguity and implements MobileMCP's stated loopback-address contract. Preserve
localNetwork behavior and all MCP dispatch/authentication semantics.

Validation: 14 focused TCP listener/failure/teardown tests passed with `swift test --build-system native --filter ...`. The Swift 6.4 default swiftbuild backend could not import the upstream macro module from its tests; native builds that same suite successfully. The patch will be rebased to MobileMCP’s original 7ecec1d pin to avoid introducing unrelated upstream changes, tested again, and retained in fork main history.

The same 14 focused tests passed after rebasing onto the original 7ecec1d revision. MobileMCP can pin this patch without taking the 37-file upstream update. The patch remains reachable through the fork main merge history.
