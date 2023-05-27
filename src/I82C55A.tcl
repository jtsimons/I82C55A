restart

# Initial values
add_force A0 1
add_force RESET 1
add_force CE 1
add_force RD 1
add_force WR 1
add_force STB 1
add_force ACK 1
run 100ns

# Output tests

# Check D7-D0 when CE# = 1, RD# = 0
add_force RESET 0
add_force RD 0
run 50ns

# Check D7-D0 when CE# = 0, RD# = 1
add_force CE 0
add_force RD 1
run 50ns

# Mode 0 Output
# Write command: CR.0 = CR.1 = CR.2 = 0
add_force -radix hex D 0x00
add_force A0 1
add_force WR 0
run 50ns
add_force WR 1
remove_force D
run 50ns

# Write data to peripheral
add_force -radix hex D 0x5A
add_force A0 0
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns
add_force -radix hex D 0xA5
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# Mode 1 Output
# Write command: CR.0 = 1, CR.1 = 1, CR.2 = 0
add_force -radix hex D 0x03
add_force A0 1
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# Read status
add_force RD 0
run 50ns
add_force RD 1
run 50ns

# Write data to peripheral
# D7-D0 = 0x3C = Px
add_force -radix hex D 0x3C
add_force A0 0
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# Read status again
add_force A0 1
add_force RD 0
run 50ns
add_force RD 1
run 50ns

# Assert ACK#
add_force ACK 0
run 50ns
add_force ACK 1
run 50ns

# Read status
add_force RD 0
run 50ns
add_force RD 1
run 50ns

# Write new data
# D7-D0 = 0xC3 = Px
add_force -radix hex D 0xC3
add_force A0 0
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# RESET
add_force RESET 1
run 50ns
add_force RESET 0
run 50ns

# Mode 1 Input (INTE = 1)
# Using the extended CR/SR registers, repeat tests

# Initial values
add_force A0 1
add_force RESET 1
add_force CE 1
add_force RD 1
add_force WR 1
add_force STB 1
add_force ACK 1
run 100ns

# Input tests

# Check D7-D0 when CE# = 1, RD# = 0
add_force RESET 0
add_force RD 0
run 50ns

# Check D7-D0 when CE# = 0, RD# = 1
add_force CE 0
add_force RD 1
run 50ns

# Load CR.0 = CR.1 = 0
add_force -radix hex D 0x04
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# Read peripheral data and transparency test
# P0-P7 = 0x5A = Dx
add_force -radix hex P 0x5A
add_force A0 0
add_force RD 0
run 50ns
# P0-P7 = 0xA5 = Dx
add_force -radix hex P 0xA5
run 50ns
# RD# = 1, check transparency again
add_force RD 1
run 50ns
add_force -radix hex P 0xA0
run 50ns

# STB# = 1
add_force STB 1
run 50ns

# Load CR.0 = CR.1 = 1
add_force -radix hex D 0x07
add_force A0 1
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# Read status
add_force CE 0
add_force A0 1
add_force RD 0
run 50ns
add_force RD 1
run 50ns

# Peripheral loads data
add_force -radix hex P 0xC3
add_force CE 1
add_force A0 0
add_force STB 0
run 50ns
add_force STB 1
run 50ns

# Read status
add_force CE 0
add_force A0 1
run 50ns
add_force RD 0
run 50ns
add_force RD 1
run 50ns

# Read data and transparency test
add_force CE 0
add_force A0 0
add_force RD 0
run 50ns
add_force -radix hex P 0xC0
run 50ns
add_force RD 1
run 50ns

# Load CR.0 = 1, CR.1 = 0
add_force -radix hex D 0x05
add_force A0 1
add_force WR 0
run 50ns
add_force WR 1
run 50ns
remove_force D
run 50ns

# Peripheral loads data
add_force -radix hex P 0xC3
add_force CE 1
add_force A0 0
add_force STB 0
run 50ns
add_force STB 1
run 50ns

# Read status
add_force CE 0
add_force A0 1
run 50ns
add_force RD 0
run 50ns
add_force RD 1
run 50ns

# Read data and transparency test
add_force CE 0
add_force A0 0
add_force RD 0
run 50ns
add_force -radix hex P 0xC0
run 50ns
add_force RD 1
run 50ns

# RESET
add_force RESET 1
run 50ns
add_force RESET 0
run 50ns
