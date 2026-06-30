
import os
import re

def build_project():
    source_dir = "src"
    output_file = "dist.lua"
    
    # We check for both capital 'Init.lua' and lowercase 'init.lua'
    init_file_variants = ["init.lua", "Init.lua"]
    init_path = None
    for variant in init_file_variants:
        path_check = variant
        if os.path.exists(path_check):
            init_path = path_check
            break

    if not init_path:
        print("Error: Main entry point (init.lua or Init.lua) not found in root directory!")
        return

    print(f"Building KazeUI Modular Project using entry point: {init_path}...")

    # Template structure simulating modular require inside a single bundled file
    build_content = """--[[
    Kaze UI Library v2.1 (Bundled Production Build)
    Generated automatically by build.py
]]

local modules = {}
local module_cache = {}

local function require(path)
    local clean_path = path:gsub("%.lua$", ""):gsub("^%./", ""):gsub("\\\\", "/")
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

    # Recursively find all modular components inside the src folder
    modular_files = []
    if os.path.exists(source_dir):
        for root, _, files in os.walk(source_dir):
            for file in files:
                if file.endswith(".lua") or file.endswith(".lua.txt"):
                    full_path = os.path.join(root, file)
                    virtual_path = full_path.replace("\\", "/").replace(".lua.txt", "").replace(".lua", "")
                    modular_files.append((virtual_path, full_path))

    # Package every modular file inside our virtual system
    for virt_path, disk_path in modular_files:
        print(f" -> Packaging Module: {virt_path}")
        with open(disk_path, "r", encoding="utf-8") as f:
            code = f.read()
            
        build_content += f'modules["{virt_path}"] = function()\n'
        build_content += code
        build_content += "\nend\n\n"

    # Append main file execution code
    print(" -> Appending main entry point...")
    with open(init_path, "r", encoding="utf-8") as f:
        init_code = f.read()
    
    # Strip any require() lines that were in the original init.lua so they don't load twice
    clean_init_code = ""
    for line in init_code.splitlines():
        if not line.strip().startswith("local") or "require(" not in line:
            clean_init_code += line + "\n"

    build_content += "-- === Main Library Execution ===\n"
    build_content += clean_init_code

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(build_content)

    print(f"\nSuccess! Production file compiled to '{output_file}'!")

if __name__ == "__main__":
    build_project()
