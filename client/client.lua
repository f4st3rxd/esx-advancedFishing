local QBCore = exports['qb-core']:GetCoreObject()

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0
local rodObj = nil 
local bait = "none"

Citizen.CreateThread(function()
while true do
	    Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
end
end)

Citizen.CreateThread(function()
	local sleep = 2000
	while true do
		Wait(sleep)
		if fishing then
			sleep = 5
			if IsControlJustReleased(0, Keys['X']) then
				fishing = false
				QBCore.Functions.Notify("Balık avlamayı durdurdunuz!", "error", 3000)

				ClearPedTasksImmediately(PlayerPedId())
				ClearPedSecondaryTask(PlayerPedId())
				DeleteEntity(rodObj)
				DeleteObject(rodObj)
			end

			
			if IsEntityInWater(PlayerPedId()) then 
				fishing = false
				QBCore.Functions.Notify("Suda balık tutamazsınız! ", "error", 3000)

				ClearPedTasksImmediately(PlayerPedId())
				ClearPedSecondaryTask(PlayerPedId())
				DeleteEntity(rodObj)
				DeleteObject(rodObj)
			end 

		else 
			sleep = 2000 
		end 
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = math.random(FastConfig.FishTime.a , FastConfig.FishTime.b)
		Wait(wait)
			if fishing then
				pause = true
				correct = math.random(1,8)

				exports['ps-ui']:Circle(function(success)
					if success then
						TriggerServerEvent('fishing:catch', bait)
					else
						QBCore.Functions.Notify("Balık kaçtı!", "error", 3000)
					end
				end, 1, 20) 
			end
	end
end)

RegisterNetEvent('fishing:break')
AddEventHandler('fishing:break', function()
	fishing = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('fishing:setbait')
AddEventHandler('fishing:setbait', function(bool)
	bait = bool
end)

BalikBolgeler = {
	[1] = { coords = vector3(-1830.31, -1206.22, 13.02), radius = 70.0 }, 
	[2] = { coords = vector3(-42.07, -1112.9, 26.44), radius = 110.0 },  
	[3] = { coords = vector3(-822.19, -1223.66, 18.22), radius = 110.0 }, 
}

RegisterNetEvent('fishing:fishstart')
AddEventHandler('fishing:fishstart', function()
	playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	if fishing then 
		QBCore.Functions.Notify("Zaten balık tutuyorsunuz!", "error", 3000)
	else 
		if IsPedInAnyVehicle(playerPed) then
			QBCore.Functions.Notify("Araçtayken balık yakalayamazsın", "error", 3000)
		else
	
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if GetDistanceBetweenCoords(pos, BalikBolgeler[1].coords, true) < BalikBolgeler[1].radius * 1.5 then
				QBCore.Functions.Notify("Balık yakalamaya başladınız", "success", 3000)
				RequestAnimDict('amb@world_human_stand_fishing@idle_a') 
				while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do 
					Wait(1) 
				end
				oltaSeviyesi = rodLevel
				fishing = true
				rodObj = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
				TaskPlayAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a', 'idle_b', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
				fishing = true
		else
				QBCore.Functions.Notify("Sadece iskelede balık tutabilirsin", "error", 3000)
		end
		end
	end 
end, false)

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(PlayerPedId(), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(PlayerPedId()))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(PlayerPedId(),2))
	AttachEntityToEntity(obj,  PlayerPedId(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end


Citizen.CreateThread(function()
    local ped_hash2 = GetHashKey("mp_m_shopkeep_01")
    local ped_coords2 = { x = -1849.35, y = -1251.25, z = 8.62 - 1, h = 324.34} 
	   
    RequestModel(ped_hash2)
    while not HasModelLoaded(ped_hash2) do
        Wait(1)
    end
    
    ped_info2 = CreatePed(1, ped_hash2, ped_coords2.x, ped_coords2.y, ped_coords2.z, ped_coords2.h, false, true)
    SetBlockingOfNonTemporaryEvents(ped_info2, true) 
    SetPedDiesWhenInjured(ped_info2, false) 
    SetPedCanPlayAmbientAnims(ped_info2, true) 
    SetPedCanRagdollFromPlayerImpact(ped_info2, false) 
    SetEntityInvincible(ped_info2, true)    
    FreezeEntityPosition(ped_info2, true) 
    TaskStartScenarioInPlace(ped_info2, "WORLD_HUMAN_GUARD_STAND", 0, true); 
end)

Citizen.CreateThread(function()
    local ped_hash2 = GetHashKey("s_m_m_migrant_01")
    local ped_coords2 = { x = -1851.88, y = -1249.19, z = 8.62 - 1, h = 324.43} 

    RequestModel(ped_hash2)
    while not HasModelLoaded(ped_hash2) do
        Wait(1)
    end
    
    ped_info2 = CreatePed(1, ped_hash2, ped_coords2.x, ped_coords2.y, ped_coords2.z, ped_coords2.h, false, true)
    SetBlockingOfNonTemporaryEvents(ped_info2, true) 
    SetPedDiesWhenInjured(ped_info2, false) 
    SetPedCanPlayAmbientAnims(ped_info2, true) 
    SetPedCanRagdollFromPlayerImpact(ped_info2, false) 
    SetEntityInvincible(ped_info2, true)    
    FreezeEntityPosition(ped_info2, true) 
    TaskStartScenarioInPlace(ped_info2, "WORLD_HUMAN_GUARD_STAND", 0, true); 
end)



CreateThread(function()
	local sleep = 2000
	while true do 
		Wait(sleep)
		local ply_coords = GetEntityCoords(PlayerPedId())
		local npc_coords = vector3(-1851.88, -1249.19, 8.62 - 1)
		local distance = #(ply_coords - npc_coords) 
	
		if distance <= 2 then 
			sleep = 3
			QBCore.Functions.DrawText3D(npc_coords.x, npc_coords.y, npc_coords.z + 1.02, "[E] - Balık Sat")

			if IsControlJustReleased(0, 38) then 
				SellItemMenu()
			end
		end
	end 	
end)

CreateThread(function()
	local sleep = 2000
	while true do 
		Wait(sleep)
		local ply_coords = GetEntityCoords(PlayerPedId())
		local npc_coords = vector3(-1849.35, -1251.25, 8.62 - 1)
		local distance = #(ply_coords - npc_coords) 
	
		if distance <= 2 then 
			sleep = 3
			QBCore.Functions.DrawText3D(npc_coords.x, npc_coords.y, npc_coords.z + 1.02, "[E] - Balık Marketi")

			if IsControlJustReleased(0, 38) then 
				OpenFishingMenu()
			end
		end
	end 	
end)

function OpenFishingMenu()
	exports['qb-menu']:openMenu({
		{
			header = 'Balıkçı',
			icon = "fa-solid fa-store",
			isMenuHeader = true, 
		},
		{
			header = 'Olta',
			txt = '$ ' .. tostring(FastConfig.OltaMiktar) ,
			icon = "fa-solid fa-arrow-right",
			params = {
				event = 'caner:fishingbuybridge',
				args = "oltaal"
			}
		},
		{
			header = 'Balık Yem',
			txt = '$ ' .. tostring(FastConfig.YemMiktar) ,
			icon = "fa-solid fa-arrow-right",
			params = {
				event = 'caner:fishingbuybridge',
				args = "yemal"
			}
		},
		{
			header = 'İllegal Balık Yem',
			txt = '$ ' .. tostring(FastConfig.KamplumbagaYem) ,
			icon = "fa-solid fa-arrow-right",
			params = {
				event = 'caner:fishingbuybridge',
				args = "illegalyem"
			}
		},
		{
			header = 'Menüyü Kapat',
			icon = 'fas fa-right-to-bracket',
			params = {
				event = ''
			}
		},	
	})
end

RegisterNetEvent("caner:fishingbuybridge", function(caner)
	local gelen_veri = caner 
	local baslik = nil 
 
	if gelen_veri == "oltaal" then
		baslik = "Olta - $" .. tostring(FastConfig.OltaMiktar)
	elseif gelen_veri == "yemal" then 
		baslik = "Balık Yemi - $" .. tostring(FastConfig.YemMiktar)
	elseif gelen_veri == "illegalyem" then 
		baslik = "İllegal Balık Yemi - $" .. tostring(FastConfig.KamplumbagaYem)
	end 

	local sellingItem = exports['qb-input']:ShowInput({
        header = baslik,
        submitText = 'Al',
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = "Miktar"
            }
        }
    })

	if sellingItem == nil then 
		return 
	else  
		TriggerServerEvent('f4st-f4st:islem', gelen_veri, sellingItem.amount) 
	end
end)

function SellItemMenu()
	-- local sellItem = exports['qb-input']:ShowInput({

    --     header = 'Balıkçılık Satış',
    --     submitText = 'Sat',
    --     inputs = {
    --         {
    --             text = "1x Balık: $" .. tostring(FastConfig.BalikFiyat), 
    --             name = "f4sttype", 
    --         }
    --     }
    -- })
	-- if sellItem == nil then 
	-- 	return 
	-- else  
	-- 	TriggerServerEvent('f4st-f4st:sell') 
	-- end


	exports['qb-menu']:openMenu({
		{
			header = 'Balıkçı',
			icon = "fa-solid fa-store",
			isMenuHeader = true, 
		},
		{
			header = 'Balık Sat',
			txt = '$ ' .. tostring(FastConfig.BalikFiyat) ,
			icon = "fa-solid fa-arrow-right",
			params = {
				event = 'f4st:bridges'
			}
		},
		
		{
			header = 'Menüyü Kapat',
			icon = 'fas fa-right-to-bracket',
			params = {
				event = ''
			}
		},	

	})
end

RegisterNetEvent("f4st:bridges", function()
	local gelen_veri = caner 
	local baslik = "Balık - $" .. tostring(FastConfig.BalikFiyat)

	local sellingItem = exports['qb-input']:ShowInput({
        header = baslik,
        submitText = 'Sat',
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = "Miktar"
            }
        }
    })

	if sellingItem == nil then 
		return 
	else  
		TriggerServerEvent('f4st-fish:sell', tonumber(sellingItem.amount)) 
	end
end)
