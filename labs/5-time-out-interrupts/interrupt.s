.data
# No need for a placeholder as we are working with 'ustatus' directly

.text
.global main

main:
    # Load immediate value into a register
    li t1, 0x01

    # Use csrrsi to set the bits specified by the immediate value in 'ustatus'
    csrrsi t0, ustatus, 0x01

    # Now 't0' contains the previous value of 'ustatus' (before setting the bits)
    # You can use 't0' as needed

    # Endless loop
    b main  # Branch to main if t0 is not equal to zero
