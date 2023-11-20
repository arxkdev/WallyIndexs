local HttpService = game:GetService("HttpService")
local function compress(n)
    return math.log(n, 2)
end

local function decompress(n)
    return 2 ^ n
end

local num = 200000
local compressed = compress(num);
print(compressed)

local decompressed = decompress(compressed);
print(tostring(decompressed))

local HttpService = game:GetService("HttpService")
local link = "https://pastebin.com/raw/eDc5weJT"

local function get()
    local data = HttpService:GetAsync(link)
    return data
end

print(get())