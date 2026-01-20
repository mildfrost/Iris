local function GetFullPath(instance: Instance): string
    local instanceNames: {[number]: string} = {}
    local currentInstance = instance
    while currentInstance.Parent ~= nil do
        table.insert(instanceNames, currentInstance.Name)
        currentInstance = currentInstance.Parent
    end
    local path = "game"
    for i = #instanceNames, 1, -1 do
        path = string.format("%s.%s", path, instanceNames[i])
    end
    return path
end

local function CustomRequire(target: ModuleScript)
    local scriptLine = `local script = {GetFullPath(target)}\n`
    local source = scriptLine .. target.Source
    local code = loadstring(source, target.Name)
    local fenv = getfenv(code)
    fenv.require = CustomRequire
    setfenv(code, fenv)
    return code()
end

local function GetIrisAssetId(): string
    if isfile("Iris.rbxm") then
        return getcustomasset("Iris.rbxm")
    end
    local res = request({
        Url = "https://github.com/mildfrost/Iris/raw/refs/heads/master/Iris.rbxm",
        Method = "GET"
    })
    if res.Success == false then
        error("Failed to request Iris model.")
        return
    end
    writefile("Iris.rbxm", res.Body)
    return getcustomasset("Iris.rbxm")
end

local irisAssetId = GetIrisAssetId()
local irisAsset = game:GetObjects(irisAssetId)[1]
irisAsset.Parent = gethui()
local Iris = CustomRequire(irisAsset)
return Iris