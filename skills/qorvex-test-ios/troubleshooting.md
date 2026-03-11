# Troubleshooting qorvex iOS Testing

## Physical Device Issues

### "Unlock X to Continue"
**Cause**: Device is locked during deployment or test execution.
**Fix**: Unlock the device and retry. Keep the device unlocked during the entire test session.

### "Timed out while enabling automation mode"
**Cause**: UI Automation is disabled on the device.
**Fix**: On the device, go to **Settings > Developer > Enable UI Automation** and toggle it on. Restart the qorvex session.

### Code signing errors
**Cause**: Physical devices require explicit code signing (simulators don't).
**Fix**: Build with these flags:
```bash
CODE_SIGNING_ALLOWED=YES \
CODE_SIGN_IDENTITY="Apple Development" \
DEVELOPMENT_TEAM=<YOUR_TEAM_ID> \
CODE_SIGN_STYLE=Automatic \
-allowProvisioningUpdates
```

### Agent not reachable on physical device
**Cause**: WiFi connectivity or hostname resolution failure.
**Checks**:
1. Device and Mac on same WiFi network?
2. Can you resolve the hostname? `dns-sd -G v4 <DeviceName>.local`
3. Is the agent port open? `nc -z <DeviceName>.local <port>`

**Important**: Use `<DeviceName>.local` (Bonjour mDNS), NOT `<DeviceName>.coredevice.local`. The `.coredevice.local` hostnames are internal to Apple's CoreDevice framework and don't resolve via standard DNS.

## Simulator Issues

### Stale session
**Symptom**: Commands return errors or no response.
**Fix**: `qorvex status` to check, then `qorvex start` to restart the session.

### Wrong architecture
**Symptom**: App crashes on launch or fails to install.
**Fix**:
- Apple Silicon Mac: build for `iossimulator-arm64`
- Intel Mac: build for `iossimulator-x64`

### Simulator not detected
**Symptom**: `qorvex start` fails to find a device.
**Fix**: Boot a simulator first: `xcrun simctl boot <udid>` or open Simulator.app.

## Common Command Issues

### Tap fails with "not found"
**Cause**: Using accessibility ID when the element only has a label (or vice versa).
**Fix**: Use `-l` flag for label matching. Run `screen-info` first to see what identifiers exist.

### Multiple elements match
**Cause**: Several elements share the same label.
**Fix**: Add `-T <Type>` to filter by element type (e.g., `-T Button`, `-T StaticText`).

### Screenshot appears blank or corrupted
**Cause**: Missing `base64 -d` decode step.
**Fix**: Always pipe: `qorvex screenshot 2>/dev/null | base64 -d > /tmp/screenshot.png`

Back to [SKILL.md](SKILL.md)
