# Add2ABM

[![License: Apache 2.0](https://img.shields.io/github/license/Inetum-Poland/add2abm?logo=apache&color=purple)](https://github.com/Inetum-Poland/add2abm?tab=Apache-2.0-1-ov-file#)
[![Platform: macOS](https://img.shields.io/badge/platform-macOS-lightgrey)](#)
[![minOS](https://img.shields.io/badge/macOS-14.0%2B-success)](#)
[![MDM: Agnostic](https://img.shields.io/badge/MDM-agnostic-blueviolet)](#)
[![GitHub Release](https://img.shields.io/github/v/release/Inetum-Poland/add2abm)](https://github.com/Inetum-Poland/add2abm/releases)
[![Shell](https://img.shields.io/badge/shell-bash-green)](#)
[![Demo](https://img.shields.io/badge/demo-video-red)](https://www.youtube.com/watch?v=DvAA_sUNB4U)

**Add2ABM is a macOS recovery-time utility script created by Inetum Poland that re-triggers Setup Assistant to allow an already configured Mac to be added to Apple Business[^1] (formerly Apple Business Manager[^2], ABM) — or Apple School Manager[^3] (ASM) without erasing the disk.**

It temporarily removes the `.AppleSetupDone` flag, as well as local user records on the **Data** volume, working around the limitations introduced in macOS Sonoma, forcing the system to present Setup Assistant on next boot. This allows the device to be (re)assigned in ABM or ASM for Automated Device Enrollment (ADE) workflows without erasing the disk.

The process is fully reversible: running the script again restores the original system state.

---

## Intended use

This tool is intended **exclusively for system administrators, support engineers, or help desk personnel** responsible for managed macOS environments.

It is used to:

- retroactively add a Mac to ABM[^1][^2]/ASM[^3] with [Apple Configurator](https://apps.apple.com/app/apple-configurator/id1588794674),
- enable Automated Device Enrollment (ADE) on an already configured Mac,
- avoid wiping a device due to data retention requirements.

[^1]: To learn more about adding devices using Apple Configurator to Apple Business, visit the [Apple Business User Guide](https://support.apple.com/guide/business/welcome/web) (currently available in a limited set of languages).
[^2]: To learn more about adding devices using Apple Configurator to Apple Business Manager, visit the [Apple Business Manager User Guide](https://support.apple.com/guide/apple-business-manager/axm200a54d59/web).
[^3]: To learn more about adding devices using Apple Configurator to Apple School Manager, visit the [Apple School Manager User Guide](https://support.apple.com/guide/apple-school-manager/axm200a54d59/web).

> [!WARNING]
> **End users should never run this script themselves.**
> The entire procedure should be carried out by, or at least under the supervision of, IT/support staff.
> Improper use may lead to system misconfiguration. While no data is deleted and all changes are reversible, a full backup before use is of course recommended.

> [!CAUTION]
> **Do not use this script on a Mac with User Activation Lock enabled or one already added to ABM/ASM**.
> Proceeding will inevitably lead to assignment failure which can put your data at risk.
>
> In fact, if for whatever reason the assignment fails, **do not use _Shut Down_** button in the bottom right corner of the Setup Assistant.
> Doing so will reset the activation status of the device and will initiate _Erase All Contents & Settings_ system wipe on next boot, even if you’d try to go straight to Recovery.
> **Use Command+Q (⌘Q)** and then Shut Down in modal window instead, or just hold the Power button to power off and potentially try again.
>
> The script has additional checks to prevent putting your data at risk, but you’re the one in control.
>
> <details>
> <summary>ABM/ASM assignment error examples</summary>
>  
>
> Activation Lock:
> ```
> Desc.  : Provisional Enrollment failed.
> Sugg.  : The device failed to request configuration from the cloud.
> Domain : DEPCloudConfigErrorDomain
> Code.  : 0x80EF (33007)
>   Domain : MCCloudConfigurationErrorDomain
>   Code.  : 0x84D0 (34000)
> ```
> Already assigned:
> ```
> Desc.  : Provisional Enrollment failed.
> Sugg.  : This device is already enrolled in the Device Enrollment Program.
> Domain : DEPCloudConfigErrorDomain
> Code.  : 0x80EF (33007)
>   Domain : MCCloudConfigurationErrorDomain
>   Code.  : 0x80FA (33018)
> ```
> Network issue:
> ```
> Desc.  : Transport could not connect.
> Domain : Catalyst.error
> Code.  : 0xCA (202)
>   Desc.  : Broadcast primitives invalidated
>   Domain : DeviceManagementTools.error
>   Code.  : 0x1E (30)
>     Desc.  : Client Disconnected
>     Domain : DeviceManagementTools.error
>     Code.  : 0x5B (91)
> ```
> </details>

> [!CAUTION]
> **Do not proceed beyond the _Select Your Country or Region_ screen** when Setup Assistant appears after running Add2ABM.
> Proceeding further may result in:
>  - duplicate or conflicting configurations,
>  - unexpected behavior on an already configured system.
>
> The sole purpose of re–triggering Setup Assistant is to allow **ABM/ASM assignment**, not to reconfigure the system.

> [!NOTE]
> Re–triggering the Setup Assistant resets end user’s consent to macOS Software License Agreement (_Terms and Conditions_ step). Add2ABM re–confirms it again in Restore mode.

---

## Requirements

- Apple silicon Mac or Intel Mac with T2 Security Chip
- Activation Lock disabled (at least temporarily)
- Access to **macOS Recovery** (make sure you have the Recovery Lock password, if set)
- Ability to unlock the Data volume using:
  - SecureToken-enabled user password, or
  - FileVault Personal Recovery Key
- Network connectivity (to download the script within macOS Recovery)

---

## Usage

Run **from macOS Recovery only**:

1. Boot into macOS Recovery
2. Open **Utilities → Terminal** (or use ⌘⇧T)
3. Execute the script from a trusted source. The following command provides the shortest command for convenient typing in Recovery Terminal:
```sh
sh <(curl -s add2abm.inetum.zone)
```
or if you’re hosting it yourself:
```sh
sh <(curl -s script_hosting_fqdn/add2abm.sh)
```
The script is fully interactive and prompts before making any changes.

Running the script from a logged–in macOS session is **not supported**.

> [!TIP]
> For security reasons, before executing the script you can verify its checksum by running
> ```sh
> curl -s add2abm.inetum.zone|md5
> curl -s script_hosting_fqdn/add2abm|md5
> ```
> or
> ```sh
> curl -s add2abm.inetum.zone|sha256
> curl -s script_hosting_fqdn/add2abm|sha256
> ```
> You can find the latest script checksums in [Releases](https://github.com/Inetum-Poland/add2abm/releases).

---

## Demo
<details>
<summary>See Add2ABM in action 🎬</summary>
 

[![Add2ABM Demo](https://img.youtube.com/vi/DvAA_sUNB4U/maxresdefault.jpg)](https://www.youtube.com/watch?v=DvAA_sUNB4U)

</details>

---

## How it works

The script operates in two modes:

- **Backup mode** (default):
  - Backs up eligible local user records (`*.plist` → `*.bak`) in `/var/db/dslocal/nodes/Default/users/`,
  - Removes `.AppleSetupDone` file located in `/var/db/`
  - Performs a reboot to trigger Setup Assistant on next boot

- **Restore mode** (when backups exist):
  - Restores user records (`*.bak` → `*.plist`)
  - Recreates `.AppleSetupDone`
  - Removes `.AppleSetupTermsOfService` to re–confirm macOS SLA
  - Performs a reboot to return the system to normal operation

---

## Complete Add2ABM procedure in 20 easy steps

1. Disable Activation Lock, if currently enabled
2. Shut down Mac
3. Hold Touch ID/power button to boot into _Options_ (macOS Recovery)
4. Authenticate as volume owner
5. Connect to network (if not connected)
6. Open **Utilities → Terminal** (or use ⌘⇧T)
7. Execute the script to backup user records and reboot
8. Unlock disk upon boot, if encrypted
9. Proceed in Setup Assistant to _Select Your Country or Region_ step
10. Bring the iPhone running _Apple Configurator_ in close proximity to the Mac
11. Add the computer to the MDM server of choice in ABM/ASM
12. Shut down Mac on success (_Mac Added_ confirmation)
13. Hold Touch ID/power button to boot into _Options_ (macOS Recovery) once again
14. Authenticate as volume owner
15. Connect to network (if not connected)
16. Open **Utilities → Terminal** (or use ⌘⇧T)
17. Execute the script again to restore user records from backup and reboot
18. Unlock disk upon boot, if encrypted
19. Log in to the local user account
20. Run `sudo profiles renew -type enrollment` (local admin account context required) in Terminal to force Automated Device Enrollment workflow from your MDM

---

## Limitations

- Requires physical access
- Not suitable for unattended or automated execution
- Depends on Apple’s current Setup Assistant and ABM behavior
- Future macOS versions may affect functionality

---

## Troubleshooting

If the script does not behave as expected, you can enable tracing to run it in a verbose mode for debugging:
```sh
sh -x <(curl -s add2abm.inetum.zone)
```
or if you’re hosting it yourself:
```sh
sh -x <(curl -s script_hosting_fqdn/add2abm.sh)
```

---

## Support

Before reporting issues, verify that:
- the script was run from macOS Recovery
- the Data volume was successfully unlocked

When reporting issues, include:
- Mac model and architecture
- macOS version
- What troubleshooting steps you’ve already taken
- Any relevant error messages or unexpected behavior observed
- Full Terminal output, if possible

---

## Contribution

Contributions are welcome! To contribute, [create a fork](https://github.com/Inetum-Poland/add2abm/fork) of this repository, commit and push changes to a branch of your fork, and then submit a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request). Your changes will be reviewed by a project maintainer.

Contributions don’t have to be code; we appreciate any help in answering [issues](https://github.com/Inetum-Poland/add2abm/issues).

---

## Credits

Add2ABM was created by the **Apple Business Unit** at **Inetum Polska Sp. z o.o.**

Add2ABM is licensed under the [Apache License, version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

 
