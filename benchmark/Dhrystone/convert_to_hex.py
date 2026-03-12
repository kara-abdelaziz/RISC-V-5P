import re
import sys

def convert_dump(input_file):
    # RISC-V NOP instruction hex
    NOP_HEX = "00000013"
    
    # Regular expression to match "address: hex_code"
    # Matches lines like "80002000: 00250513"
    pattern = re.compile(r"^([0-9a-fA-F]+):\s+([0-9a-fA-F]{8})\s+")

    # We assume the ROM starts at 0x80000000
    expected_addr = 0x80000000
    
    output_filename = input_file.replace(".dump", "") + ".hex"

    try:
        with open(input_file, 'r') as f, open(output_filename, 'w') as out:
            # Write Digital Header
            out.write("v2.0 raw\n")
            
            for line in f:
                # Stop if we hit the data section (handled by separate dmem.hex)
                if "Disassembly of section .data" in line:
                    break
                
                match = pattern.match(line.strip())
                if match:
                    current_addr = int(match.group(1), 16)
                    instruction_hex = match.group(2)

                    # Fill the gap between last address and current address with NOPs
                    while expected_addr < current_addr:
                        out.write(f"{NOP_HEX}\n")
                        expected_addr += 4
                    
                    # Write the actual instruction
                    out.write(f"{instruction_hex}\n")
                    expected_addr = current_addr + 4

        print(f"Successfully created {output_filename}")
        print(f"Final Address reached: {hex(expected_addr - 4)}")

    except FileNotFoundError:
        print(f"Error: Could not find file {input_file}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 smart_convert.py <file.dump>")
    else:
        convert_dump(sys.argv[1])