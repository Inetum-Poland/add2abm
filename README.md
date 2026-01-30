# Add2ABM

![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Shell](https://img.shields.io/badge/shell-bash-green)
![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)

**Add2ABM is a macOS recovery-time utility script created by Inetum Poland that re-triggers Setup Assistant to allow an already configured Mac to be added to Apple Business Manager[^1] (ABM) or Apple School Manager[^2] (ASM) without erasing the disk.**

It temporarily removes the `.AppleSetupDone` flag, as well as local user records on the **Data** volume, working around the limitations introduced in macOS Sonoma, forcing the system to present Setup Assistant on next boot. This allows the device to be (re)assigned in ABM or ASM for Automated Device Enrollment (ADE) workflows without erasing the disk.

The process is fully reversible: running the script again restores the original system state.

---

## Intended use

This tool is intended **exclusively for system administrators, support engineers, or help desk personnel** responsible for managed macOS environments.

It is used to:

- retroactively add a Mac to ABM[^1]/ASM[^2] with [Apple Configurator](https://apps.apple.com/app/apple-configurator/id1588794674),
- enable Automated Device Enrollment (ADE) on an already configured Mac,
- avoid wiping a device due to data retention requirements.

[^1]: To learn more about adding devices using Apple Configurator to Apple Business Manager, visit the [Apple Business Manager User Guide](https://support.apple.com/guide/apple-business-manager/axm200a54d59/web).
[^2]: To learn more about adding devices using Apple Configurator to Apple School Manager, visit the [Apple School Manager User Guide](https://support.apple.com/guide/apple-school-manager/axm200a54d59/web).

> [!WARNING]
> **End users should never run this script themselves.**
> The entire procedure should be carried out by, or at least under the supervision of, IT/support staff.
> Improper use may lead to system misconfiguration. While no data is deleted and all changes are reversible, a full backup before use is of course recommended.

> [!CAUTION]
> **Do not proceed beyond the _Country & Region_ selection screen** when Setup Assistant appears after running Add2ABM.
> Proceeding further may result in:
>  - duplicate or conflicting configurations,
>  - unexpected behavior on an already configured system.
>
> The sole purpose of re–triggering Setup Assistant is to allow **ABM/ASM assignment**, not to reconfigure the system.

> [!NOTE]
> Re–triggering the Setup Assistant resets end users’ consent to macOS _Terms and Conditions_ and these will have to be accepted again upon disabling the Setup Assistant.

---

## Requirements

- Apple silicon Mac or Intel Mac with T2 Security Chip
- Access to **macOS Recovery** (make sure you have the Recovery Lock password, if set)
- Ability to unlock the Data volume using:
  - SecureToken-enabled user password, or
  - FileVault Personal Recovery Key
- Network connectivity (to download the script within macOS Recovery)

---

## Usage

Run **from macOS Recovery only**:

1. Boot into macOS Recovery
2. Open **Utilities → Terminal**
3. Execute the script from a trusted source. The following command provides the shortest command for convenient typing in Recovery Terminal:
```sh
sh <(curl -s script_hosting_fqdn/add2abm)
```
The script is fully interactive and prompts before making any changes.

Running the script from a logged–in macOS session is **not supported**.

> [!TIP]
> For security reasons, before executing the script you can verify its checksum by running
> ```sh
> curl -s script_hosting_fqdn/add2abm|md5
> ```
> or
> ```sh
> curl -s script_hosting_fqdn/add2abm|sha256
> ```
> You can find the latest script checksums in [Releases](https://github.com/Inetum-Poland/add2abm/releases).

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
  - Performs a reboot to return the system to normal operation

---

## Complete Add2ABM procedure in 20 easy steps

1. Shut down Mac
2. Hold Touch ID/power button to boot into _Options_ (macOS Recovery)
3. Authenticate as volume owner
4. Connect to network (if not connected)
5. Open **Utilities → Terminal**
6. Execute the script to backup user records and reboot
7. Unlock disk upon boot, if encrypted
8. Proceed in Setup Assistant to _Country & Region_ step
9. Bring the iPhone running _Apple Configurator_ in close proximity to the Mac
10. Add the computer to the MDM server of choice in ABM/ASM
11. Shut down Mac on success (_Mac Added_ confirmation)
12. Hold Touch ID/power button to boot into _Options_ (macOS Recovery) once again
13. Authenticate as volume owner
14. Connect to network (if not connected)
15. Open **Utilities → Terminal**
16. Execute the script again to restore user records from backup and reboot
17. Unlock disk upon boot, if encrypted
18. Agree to macOS _Terms and Conditions_
19. Log in to the local user account
20. Run `sudo profiles renew -type enrollment` (local admin account context required) in Terminal to force Automated Device Enrollment workflow from your MDM

---

## Limitations

- Requires physical access
- Not suitable for unattended or automated execution
- Depends on Apple’s current Setup Assistant and ABM behavior
- Future macOS versions may affect functionality

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

 
