
import os
import re

def build_project():
    source_dir = "src"
    output_file = "dist.lua"
    
    if not os.path.exists(source_dir):
        print(f"Error: '{source_dir}' directory not found.")
        return

    print("Building KazeUI Modular Project...")

    # Template setup
    build_content = """--[[
    Kaze UI Library v2.1 (Bundled Production Build)
    Generated automatically by build.py
]]

-- Virtual File System (VFS) Module Loader simulation
local modules = {}
local module_cache = {}

local function require(path)
    -- Normalize path
    local clean_path = path:gsub("%.lua$", ""):gsub("^%./", ""):gsub("\\\\", "/")
    
    -- Check cache
    if module_cache[clean_path] then
        return module_cache[clean_path]
    end
    
    local loader = modules[clean_path]
    if not loader then
        error("Module not found in virtual filesystem: " .. tostring(clean_path))
    end
    
    local result = loader()
    module_cache[clean_path] = result
    return result
end

"""

    # Recursively find all .lua files in src/ except Init.lua
    modular_files = []
    init_path = None

    for root, _, files in os.walk(source_dir):
        for file in files:
            if file.endswith(".lua") or file.endswith(".lua.txt"):
                full_path = os.path.join(root, file)
                # Format to uniform forward slash format
                virtual_path = full_path.replace("\\", "/").replace(".lua.txt", "").replace(".lua", "")
                
                if virtual_path.lower() == "src/init":
                    init_path = full_path
                else:
                    modular_files.append((virtual_path, full_path))

    # Add each module to the VFS
    for virt_path, disk_path in modular_files:
        print(f" -> Packaging Module: {virt_path}")
        with open(disk_path, "r", encoding="utf-8") as f:
            code = f.read()
            
        # Wrap module in a function environment
        build_content += f'modules["{virt_path}"] = function()\n'
        build_content += code
        build_content += "\nend\n\n"

    # Finally, append the Init.lua code to execute it
    if init_path:
        print(" -> Appending main entry point (Init.lua)...")
        with open(init_path, "r", encoding="utf-8") as f:
            init_code = f.read()
        build_content += "-- === Main Library Execution ===\n"
        build_content += init_code
    else:
        print("Warning: src/Init.lua main entry point was not found!")

    # Write output build file
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(build_content)

    print(f"\nSuccess! Production file compiled to '{output_file}'!")

if __name__ == "__main__":
    build_project()
