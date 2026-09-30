# MobileMCP loopback binding patch

Tracked by https://github.com/advatar/BrIAn/issues/361 (fork issues are disabled).

- [x] Reproduce the localUser wildcard socket accepting a same-host LAN-address connection.
- [x] Require an explicit loopback local endpoint as well as the loopback interface.
- [x] Cover both local scopes, IPv4/IPv6 selection, and fixed/ephemeral ports.
- [ ] Run focused transport tests, commit and push, and pin the patch in MobileMCP.

The interface constraint already restricts paths; a same-host LAN-address connection
is not proof of access from another machine. Explicit address binding removes that
ambiguity and implements MobileMCP's stated loopback-address contract. Preserve
localNetwork behavior and all MCP dispatch/authentication semantics.

Validation: 14 focused TCP listener/failure/teardown tests passed with `swift test --build-system native --filter ...`. The Swift 6.4 default swiftbuild backend could not import the upstream macro module from its tests; native builds that same suite successfully. The patch will be rebased to MobileMCP’s original 7ecec1d pin to avoid introducing unrelated upstream changes, tested again, and retained in fork main history.
