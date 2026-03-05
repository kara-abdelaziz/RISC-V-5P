#!/bin/bash

# --- Script to convert a RISC-V objdump file to Logisim's v2.0 raw hex format ---

# 1. Check if an input file was provided as an argument.
#    $# is a special variable that holds the number of arguments.
if [ $# -eq 0 ]; then
    echo "Error: No input file provided."
    echo "Usage: $0 <path_to_your_file.dump>"
    exit 1
fi

# 2. Store the input filename from the first argument ($1) in a variable.
DUMP_FILE="$1"

#    Check if the file actually exists before proceeding.
if [ ! -f "$DUMP_FILE" ]; then
    echo "Error: File not found: '$DUMP_FILE'"
    exit 1
fi

# 3. Create the output filename.
#    ${DUMP_FILE%.*} is a shell feature that removes the extension from the filename.
#    It removes the shortest match of '.*' (a dot followed by any characters) from the end.
#    Example: "rv32ui-p-add.dump" becomes "rv32ui-p-add".
#    We then append the new .hex extension.
HEX_FILE="${DUMP_FILE%.*}.hex"

# --- Core Logic ---

# 4. Create the new .hex file and write the required Logisim header into it.
#    The '>' operator creates the file or overwrites it if it already exists.
echo "v2.0 raw" > "$HEX_FILE"

# 5. Run the grep/sed command on the input file to extract the machine code,
#    and append (>>) the results to the .hex file we just created.

sed '/Disassembly of section \.data:/,$d' "$DUMP_FILE" | grep -E "^\s*[0-9a-f]+:" | sed -E 's/^\s*[0-9a-f]+:\s*([0-9a-f]+)\s*.*/\1/' >> "$HEX_FILE"


# 6. Print a success message to let the user know it's done.
echo "Successfully converted '$DUMP_FILE' to '$HEX_FILE'"
