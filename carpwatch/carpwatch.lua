_addon.author   = 'Jaza (Jaza#6599)';
_addon.name     = 'CarpWatch';
_addon.version  = '0.1.0';


require 'common'

local inventory = AshitaCore:GetDataManager():GetInventory()
local pos = {50, 50}


ashita.register_event('load', function()
    pos = ashita.settings.load_merged(_addon.path .. 'position.json', pos)

    local f = AshitaCore:GetFontManager():Create('__carpwatch')
    f:SetBold(false)
    f:SetColor(0xFFFFFFFF)
    f:SetFontFamily('Consolas')
    f:SetFontHeight(10)
    f:SetPositionX(pos[1])
    f:SetPositionY(pos[2])
    f:SetText('')
    f:GetBackground():SetColor(0x80000000)
    f:GetBackground():SetVisibility(true)
end)


ashita.register_event('unload', function()
    local f = AshitaCore:GetFontManager():Get('__carpwatch')
    pos = {f:GetPositionX(), f:GetPositionY()}
    ashita.settings.save(_addon.path .. 'position.json', pos)
    AshitaCore:GetFontManager():Delete('__carpwatch')
end)


ashita.register_event('render', function()
    local f = AshitaCore:GetFontManager():Get('__carpwatch')
    if (f == nil) then return end
   
    local inv_max = inventory:GetContainerMax(0)
    -- 0 = inventory
    -- ref: https://git.ashitaxi.com/Addons/find/src/branch/master/find.lua
    if (inv_max == 0) then
        f:SetVisibility(false)
        return
    end
    
    local carp_count = 0
    local used_space = 0
    for x = 1, inv_max, 1 do
        item = inventory:GetItem(0, x)
        if (item ~= nil) then
            if (item.Id ~= 0) then
                used_space = used_space +1
            end
            if (item.Id == 4401 or item.Id == 5789 or
                item.Id == 4289 or item.Id == 4427) then
                    carp_count = carp_count + item.Count
            end
        end
    end

    local inv_count = string.format("(%d/%d)", used_space, inv_max-1)
    local txt = ""

    txt = string.format("%8s  Inventory", inv_count)
    if ((inv_max-used_space) < 2) then
        txt = string.format('|c0xFFFF0000|%s|r', txt)
    elseif ((inv_max-used_space) < 5) then
        txt = string.format('|c0xFFFF9999|%s|r', txt)
    end
    
    txt = txt .. string.format("\n%8d  Carp(s)", carp_count)

    f:SetText(txt)
    f:SetVisibility(true)

end)