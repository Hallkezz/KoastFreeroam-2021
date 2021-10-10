class 'Menu'

function Menu:__init()
	--Chat:Broadcast( "[Сервер] ", Color.White, "Был выполнен рестарт серверного мода. Появились баги? Перезайдите!", Color.Yellow )

	Network:Subscribe( "IsChecked", self, self.IsChecked )

	Network:Subscribe( "SetFreeroam", self, self.SetFreeroam )
	Network:Subscribe( "SetEng", self, self.SetEng )
	Network:Subscribe( "SetRus", self, self.SetRus )
	Network:Subscribe( "Exit", self, self.Exit )
	Network:Subscribe( "GoMenu", self, self.GoMenu )

	Events:Subscribe( "PlayerJoin", self, self.PlayerJoin )
end

function Menu:IsChecked( args, sender )
	sender:SetNetworkValue( "Warned", 1 )
end

function Menu:SetFreeroam( args, sender )
	sender:SetNetworkValue( "GameMode", "FREEROAM" )
end

function Menu:SetEng( args, sender )
	sender:SetNetworkValue( "Warned", 1 )

	Chat:Send( sender, "Welcome to Rashan Koast Freeroam! Have a good game :3", Color( 200, 120, 255 ) )
	Chat:Send( sender, "==============", Color( 255, 255, 255 ) )
	Chat:Send( sender, "> Players List: ", Color.White, "F5", Color.Yellow )
	Chat:Send( sender, "> Server Map: ", Color.White, "F2", Color.Yellow )
	Chat:Send( sender, "> Server Menu: ", Color.White, "B", Color.Yellow )
	Chat:Send( sender, "==============", Color( 255, 255, 255 ) )
	sender:SetNetworkValue( "Lang", "ENG" )
end

function Menu:SetRus( args, sender )
	if sender:GetMoney() <= 1 then
		sender:SetNetworkValue( "Warned", 1 )
	end
	sender:SetNetworkValue( "Lang", "РУС" )
end

function Menu:Exit( args, sender )
	sender:Kick()
end

function Menu:GoMenu( args, sender )
	Network:Send( sender, "BackMe" )
end

function Menu:PlayerJoin( args )
	Chat:Send( args.player, "Добро пожаловать на Рашан Koast Freeroam! Приятной игры :3", Color( 200, 120, 255 ) )
	Chat:Send( args.player, "==============", Color( 255, 255, 255 ) )
	Chat:Send( args.player, "> Список игроков: ", Color.White, "F5", Color.Yellow )
	Chat:Send( args.player, "> Серверная карта: ", Color.White, "F2", Color.Yellow )
	Chat:Send( args.player, "> Меню сервера: ", Color.White, "B", Color.Yellow )
	Chat:Send( args.player, "==============", Color( 255, 255, 255 ) )
end

menu = Menu()