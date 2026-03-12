import sys

def parse_hex_to_asm(filename):
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Error: {filename} not found.")
        return

    current_addr = 0
    byte_buffer = []

    print("# --- DATA LOADING ROUTINE ---")
    print("load_data_to_ram:")

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # If it's an address line (e.g., @80005570)
        if line.startswith('@'):
            # If we had leftovers in the buffer, we ignore them (shouldn't happen in valid hex)
            byte_buffer = []
            current_addr = int(line[1:], 16)
            print(f"\n  # Loading block starting at 0x{current_addr:08x}")
            print(f"  li t0, 0x{current_addr:08x}")
            continue

        # If it's a data line (e.g., 44 48 52 59 ...)
        bytes_list = line.split()
        for b in bytes_list:
            byte_buffer.append(b)
            
            # Once we have 4 bytes, we form a 32-bit word
            if len(byte_buffer) == 4:
                # RISC-V is LITTLE ENDIAN
                # Bytes [B0, B1, B2, B3] become 0xB3B2B1B0
                word = byte_buffer[3] + byte_buffer[2] + byte_buffer[1] + byte_buffer[0]
                
                print(f"  li t1, 0x{word}")
                print(f"  sw t1, 0(t0)")
                
                print(f"  addi t0, t0, 4")
                byte_buffer = []

    print("  ret")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 hex_to_asm.py dmem.hex")
    else:
        parse_hex_to_asm(sys.argv[1])