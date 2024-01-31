#!/bin/bash

# base conversions
s2i() {
	local usage="\
usage: ${FUNCNAME[0]} STR

  STR is either a bit string (maximum 32 bits) or, if prefixed with '0x', an
  hexadecimal string (maximum 8 hexits). STR is first extended to 32 bits by
  adding zeros on the left and the result is considered as an unsigned number
  (U), a signed number in sign and magnitude (SM), and a signed number in 2's
  complement (TC). U is printed in bases 2, 10 and 16, SM and TC are printed in
  base 10.
"
	local n
	local -i i
	local -a v=()

	n="${1^^}"
    if (( $# != 1 )); then
        printf '%s' "$usage"
        return 1
    fi
	if [[ "$n" =~ ^0X[0-9A-F]+$ ]]; then
		i=16
		n="${n:2}"
        if (( "${#n}" > 8 )); then
            printf '%s: invalid string (maximum 8 hexits)\n' "$1"
            printf '%s' "$usage"
            return 1
        fi
	elif [[ "$n" =~ ^[0-1]+$ ]]; then
		i=2
		n="${n:2}"
        if (( "${#n}" > 32 )); then
		    printf '%s: invalid string (maximum 32 bits)\n' "$1"
            printf '%s' "$usage"
		    return 1
        fi
    else
		printf '%s: invalid string\n' "$1"
        printf '%s' "$usage"
		return 1
	fi
	mapfile -t v < <(printf 'ibase=%s\nn=%s\nn\nobase=2\nn\n' "$i" "$n" | bc)
	printf -v v[1] '%+32s' "${v[1]}"
    v[1]="${v[1]// /0}"
    if (( v[0] >= 2**31 )); then
        (( v[2] = 2**31 - v[0] ))
        (( v[3] = v[0] - 2**32 ))
    else
        (( v[2] = v[0] ))
        (( v[3] = v[0] ))
    fi
	printf 'U (base 2):   %s\nU (base 10):  %d\nU (base 16):  %08X\nSM (base 10): %d\nTC (base 10): %d\n' "$( sed -E 's/(....)/\1 /g' <<< "${v[1]}" )" "${v[0]}" "${v[0]}" "${v[2]}" "${v[3]}"
	return 0
}

