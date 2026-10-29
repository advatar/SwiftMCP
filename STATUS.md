# Observation connection lifecycle — BrIAn #692

Tracked by https://github.com/advatar/BrIAn/issues/692 (fork issues are disabled).

- [x] Reproduce observation context remaining live during TCP clean-EOF draining at 351fe256.
- [x] Expose transport-owned peer-input closure without changing ordinary half-close reply semantics.
- [x] 55 TCP/HTTP disconnect, teardown, failure, session and send-stall tests passed on macOS at swift-log 1.10.1 (bbd81b6725ae874c69e9b8c8804d462356b55523), JSONFoundation 3.2.1 (faceccfb9c72c9ba7c872053fc7cf479c1dc1a76).
- [x] Prepare draft dependency for BrIAn #692; no merge or production enablement.

## 2026-10-29 review follow-up

- Added explicit review-branch push triggers for the existing platform and lint workflows.
- Added macOS minimum swift-log 1.10.1 alongside latest resolution. A fresh whole-package build found both demo OSLog handlers still required 1.11; both now use the common LogHandler signature.
- Extracted the unchanged synchronized disconnect marker and TCP recording fixture to keep file lengths within existing lint limits. Full strict local SwiftLint passes; no global rule suppression.
- Native lifecycle tests and hosted platform gates must qualify the new head before review completion. Production remains disabled downstream; no merge.

### Windows full-suite finding

Run 40833550599 passed all required jobs, but the optional Windows full suite
reported one failed occupied-port bind test (659 tests, one issue). Winsock's
SO_REUSEADDR permits overlapping listeners, unlike the intended lifecycle
contract. The adapter now requests SO_EXCLUSIVEADDRUSE before binding on Windows;
Unix reuse behavior is unchanged. The existing failed-bind/restart regression
must pass in the full Windows suite before this finding is considered resolved.
Both full Windows steps are now enforced, so this regression cannot hide behind
a green job again.
Reference: https://learn.microsoft.com/en-us/windows/win32/winsock/so-exclusiveaddruse

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
