#!/bin/bash

# Add2ABM

# Copyright 2026 Inetum Polska Sp. z o.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Bartłomiej Sojka
# Revision: 20250805
REVISION=20250805

# Usage: sh <(curl -s add2abm.inetum.zone)
#        sh <(curl -s script_hosting_fqdn/add2abm)

# CONFIRMATION: ————————————————————————————————————————————————————————————————————————————————————

printf 'Add2ABM script by Inetum Polska Sp. z o.o.\nRevision: %s\nWould you like to run it now? (y/n): ' ${REVISION}
read -r ANSWER
case "${ANSWER}" in
	[Yy]*)
		unset ANSWER
		;;
	*) exit 0 ;;
esac

# PREREQUISITES: ———————————————————————————————————————————————————————————————————————————————————

DB_PATH="/Volumes/Macintosh HD/var/db"
ASD_FILE="${DB_PATH}/.AppleSetupDone"
USERS_PATH="${DB_PATH}/dslocal/nodes/Default/users"
DATA_VOLUME="Macintosh HD - Data"

# MOUNTING: ————————————————————————————————————————————————————————————————————————————————————————

! grep -q "${DATA_VOLUME}" <<<"$(diskutil list)" && DATA_VOLUME="Data"
if ! diskutil mount "${DATA_VOLUME}" &>/dev/null; then
	printf '\nPlease, provide SecureToken–enabled user password or a FileVault Personal Recovery Key to unlock Data volume…\n'
	diskutil apfs unlockVolume "${DATA_VOLUME}"
fi

if [[ ! -d "${USERS_PATH}" ]]; then
	printf 'Data volume still locked or path does not exist. Terminating…\n'
	exit 1
fi

# RESTORE: —————————————————————————————————————————————————————————————————————————————————————————

# Check for any .bak files:
if ls "${USERS_PATH}"/*.bak &>/dev/null; then
	printf '\n[*] Found .bak files. Restoring…\n'
	for BACKUP_FILE in "${USERS_PATH}"/*.bak; do
		[ -e "${BACKUP_FILE}" ] || continue
		mv -v "${BACKUP_FILE}" "${BACKUP_FILE%.bak}.plist"
	done

	printf '\n[*] Restoring AppleSetupDone…\n'
	touch "${ASD_FILE}"
	chmod 400 "${ASD_FILE}"

	printf "\n[✓] Restore complete. Note that you’ll have to agree to Terms & Conditions again.\n"

	printf '\nWould you like to restart to macOS now? (y/n): '
	read -r ANSWER
	case "${ANSWER}" in
		[Yy]*)
			printf 'Performing restart…'
			sleep 0.5
			reboot
			;;
	esac

	exit 0
fi

# BACKUP: ——————————————————————————————————————————————————————————————————————————————————————————

# No .bak files found — backup eligible .plist files:
printf "\n[*] No .bak files found. Backing up local users’ .plist files…\n"

for USER_FILE in "${USERS_PATH}"/*.plist; do
	# Skip files starting with underscore:
	[[ "$(basename "${USER_FILE}")" == _* ]] && continue

	# Extract the first UID from the plist:
	USER_UID=$(plutil -extract uid.0 raw "${USER_FILE}" 2>/dev/null)

	# Skip if no UID was found or it's not a number:
	[[ -z "${USER_UID}" || ! "${USER_UID}" =~ ^[0-9]+$ ]] && continue

	# Check if UID is greater than 500:
	if ((USER_UID > 500)); then
		printf 'Backing up "%s" (UID: %s)…\n' "$(basename "${USER_FILE%.plist}")" "${USER_UID}"
		mv -v "${USER_FILE}" "${USER_FILE%.plist}.bak"
		# place your action here if needed
	fi
done

printf '\n[*] Removing AppleSetupDone…\n'
rm -f "${ASD_FILE}"

printf '\n[✓] Backup complete. macOS Setup Assistant will now open upon drive unlock.\n'

printf '\nWould you like to restart to macOS now? (y/n): '
read -r ANSWER
case "${ANSWER}" in
	[Yy]*)
		printf 'Performing restart…'
		sleep 0.5
		reboot
		;;
esac

exit 0
