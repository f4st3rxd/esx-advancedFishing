local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('turtlebait', function(source)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName("turtlebait").amount > 0 then
		TriggerClientEvent('fishing:setbait', src, "turtle")
		Player.Functions.RemoveItem("turtlebait", 1)
		TriggerClientEvent("QBCore:Notify", src , "Yemi yemini oltana takıyorsun", "success", 3000)
	else
		TriggerClientEvent("QBCore:Notify", src , "Oltanız yok", "error", 3000)
	end
end)

QBCore.Functions.CreateUseableItem('fishbait', function(source)
	local src = source 
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName("fishbait").amount > 0 then
		TriggerClientEvent('fishing:setbait', src, "fish")
		Player.Functions.RemoveItem("fishbait", 1)
		TriggerClientEvent("QBCore:Notify", src , "Balık yemini oltana takıyorsun", "success", 3000)
	else
		TriggerClientEvent("QBCore:Notify", src , "Oltanız yok", "error", 3000)
	end

end)

QBCore.Functions.CreateUseableItem('turtle', function(source)
	local src = source 
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName("turtle").amount > 0 then
		TriggerClientEvent('fishing:setbait', src, "shark")
		

		Player.Functions.RemoveItem("turtle", 1)
		TriggerClientEvent("QBCore:Notify", src , "Yemi oltana takıyorsun", "success", 3000)
	else
		TriggerClientEvent("QBCore:Notify", src , "Oltanız yok", "error", 3000)
	end

end)

QBCore.Functions.CreateUseableItem('fishingrod', function(source)
	local src = source
	TriggerClientEvent('fishing:fishstart', src)
end)

RegisterNetEvent('fishing:catch')
AddEventHandler('fishing:catch', function(bait)
	local src = source 
	local weight = 2
	local rnd = math.random(1,100)
	local Player = QBCore.Functions.GetPlayer(src)
	if bait == "turtle" then
		if rnd >= 50 then
			if rnd >= 94 then
				TriggerClientEvent('fishing:setbait', src, "none")
				TriggerClientEvent("QBCore:Notify", src , "Çok büyüktü ve oltanı kırdı!", "error", 3000)
				TriggerClientEvent('fishing:break', src)
				Player.Functions.RemoveItem('fishingrod', 1)
			else
				TriggerClientEvent('fishing:setbait', src, "none")
				TriggerClientEvent("QBCore:Notify", src , "Bir köpekbalığı yakaladın! Bunlar nesli tükenmekte olan türlerdir ve bulundurulması yasaktır.", "error", 3000)
					Player.Functions.AddItem('shark', 1)
			end
		else
			if rnd >= 75 then
					TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
					Player.Functions.AddItem('fish', math.random(1,2))
				
			else
					TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
					Player.Functions.AddItem('fish', math.random(1,2))
			end
		end
	else
		if bait == "fish" then
			if rnd >= 75 then
				TriggerClientEvent('fishing:setbait', src, "none")
					TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
					Player.Functions.AddItem('fish', math.random(1,2))
				
			else
					TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
					Player.Functions.AddItem('fish', math.random(1,2))
			end
		end
		if bait == "none" then
			if rnd >= 70 then
				TriggerClientEvent("QBCore:Notify", src , "Şu anda herhangi bir donanımlı yem olmadan avlanıyorsunuz.", "error", 3000)
						TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
					    Player.Functions.AddItem('fish', 1)
					
				else
					TriggerClientEvent("QBCore:Notify", src , "Şu anda herhangi bir donanımlı yem olmadan avlanıyorsunuz.", "error", 3000)
						TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
					    Player.Functions.AddItem('fish', 1)
				end
		end
		if bait == "shark" then
			if rnd >= 52 then
						if rnd >= 91 then
							TriggerClientEvent('fishing:setbait', src, "none")
							TriggerClientEvent("QBCore:Notify", src , "Çok büyüktü ve oltanı kırdı!.", "error", 3000)
							TriggerClientEvent('fishing:break', src)
							Player.Functions.RemoveItem('fishingrod', 1)
						else
								    TriggerClientEvent("QBCore:Notify", src , "Bir köpekbalığı yakaladın! Bunlar nesli tükenmekte olan türlerdir ve bulundurulması yasaktır.", "error", 3000)
									Player.Functions.AddItem("shark", 1)
						end	
							else
									TriggerClientEvent("QBCore:Notify", src , "Balık yakaladın .", "success", 3000)
									Player.Functions.AddItem('fish', math.random(1,2))
						end
			end
		end
end)

RegisterServerEvent("f4st-f4st:islem")
AddEventHandler("f4st-f4st:islem", function(typee, miktar)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local BankMoney = Player.Functions.GetMoney("bank")
	local CashMoney = Player.Functions.GetMoney("cash")

	-- FIYATLAR --
	local RodMoney = FastConfig.OltaMiktar 
	local YemMiktar = FastConfig.YemMiktar
	local KamplumbagaYem = FastConfig.KamplumbagaYem
    -- FIYATLAR --

	local type = typee
	local amount = miktar 


	if tonumber(amount) < 0 then 
		TriggerClientEvent("QBCore:Notify", src, "Hatalı argüman girdiniz!", "error", 3000)
	else
		if type == "oltaal" then 
			local card_ = RodMoney * amount 

			if CashMoney > card_ then 
				TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. " tane olta satın aldınız!", "success", 3000)
				Player.Functions.RemoveMoney("cash", card_, "İskele olta satın alım işlemi")
				Player.Functions.AddItem("fishingrod", amount)
			elseif BankMoney > card_ then 
				TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. " tane olta satın aldınız!", "success", 3000)
				Player.Functions.RemoveMoney("bank", card_, "İskele olta satın alım işlemi")
				Player.Functions.AddItem("fishingrod", amount)
			else 
				TriggerClientEvent("QBCore:Notify", src, "Yeterli paranız bulunmamakta", "error", 3000)
			end 
		elseif type == "yemal" then 
			local card_ = YemMiktar * amount 

			if CashMoney > card_ then 
				TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. " tane balık yemi satın aldınız!", "success", 3000)
				Player.Functions.RemoveMoney("cash", card_, "İskele balık yemi satın alım işlemi")
				Player.Functions.AddItem("fishbait", amount)
			elseif BankMoney > card_ then 
				TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. " tane balık yemi satın aldınız!", "success", 3000)
				Player.Functions.RemoveMoney("bank", card_, "İskele balık yemi satın alım işlemi")
				Player.Functions.AddItem("fishbait", amount)
			else 
				TriggerClientEvent("QBCore:Notify", src, "Yeterli paranız bulunmamakta", "error", 3000)
			end 
		elseif type == "illegalyem" then
			local card_ = KamplumbagaYem * amount 

			if CashMoney > card_ then 
				TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. " tane köpekbalığı yemi satın aldınız!", "success", 3000)
				Player.Functions.RemoveMoney("cash", card_, "İskele köpekbalığı yemi satın alım işlemi")
				Player.Functions.AddItem("turtlebait", amount)
			elseif BankMoney > card_ then 
				TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. amount .. " tane köpekbalığı yemi satın aldınız!", "success", 3000)
				Player.Functions.RemoveMoney("bank", card_, "İskele köpekbalığı yemi satın alım işlemi")
				Player.Functions.AddItem("turtlebait", amount)
			else 
				TriggerClientEvent("QBCore:Notify", src, "Yeterli paranız bulunmamakta", "error", 3000)
			end 
		else 
			TriggerEvent("ria-logs:server:CreateLog", "f4st-antiexploit", "", "orange", "``" .. GetPlayerName(src) .. "(".. src ..")``, Citizen ID = " .. Player.PlayerData.citizenid .." adlı oyuncu balık scripti üzerinde trigger tetiklemeyi denedi f4st3r baba engelledi tabiki" )
			DropPlayer(src, "{f4st-antiexploit}: anti fishing exploit")
		end		
	end	
end)

RegisterServerEvent("f4st-fish:sell")
AddEventHandler("f4st-fish:sell", function(miktar)
	local src = source 
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName("fish") == nil then 
		TriggerClientEvent("QBCore:Notify", src, "Üstünüzde yeterli balık yok!", "error", 3000)
	else 
		local PlayerItem = Player.Functions.GetItemByName("fish")
		if PlayerItem.amount > miktar then 
			Player.Functions.RemoveItem("fish", miktar)
			Player.Functions.AddMoney("cash", miktar * FastConfig.BalikFiyat, "Balık satış") 
			TriggerClientEvent("QBCore:Notify", src, "Başarıyla " .. miktar .. "x balık sattınız $" .. miktar * FastConfig.BalikFiyat .. " elde ettiniz", "success", 3000)
			TriggerEvent("ria-logs:server:CreateLog", "f4st-baliklog", "", "orange", "``" .. GetPlayerName(src) .. "(".. src ..")``, Citizen ID = " .. Player.PlayerData.citizenid .." adlı oyuncu ``" .. miktar .. "x`` tane balık satarak  ``" .. miktar * FastConfig.BalikFiyat .. "$`` elde etti. " )
		else
			TriggerClientEvent("QBCore:Notify", src, "Üstünüzde yeterli balık yok!", "error", 3000)
		end
	end 
end)
