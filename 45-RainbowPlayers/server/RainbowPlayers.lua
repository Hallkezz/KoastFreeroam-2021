class "RainbowCars"

function RainbowCars:__init()
    self.prefix = "[ЛГБТ] "

    self.rT = Timer()

    Events:Subscribe( "PreTick", self, self.PreTick )
    Events:Subscribe( "PlayerChat", self, self.PlayerChat )
end

function RainbowCars:PlayerChat( args )
	if args.player:GetValue( "Tag" ) == "Creator" or args.player:GetValue( "Tag" ) == "GlAdmin" or args.player:GetValue( "Tag" ) == "Admin"
		or args.player:GetValue( "Tag" ) == "AdminD" then
        if args.text == "/rnb" then
            if args.player:GetValue( "RainbowCar" ) then
                args.player:SetNetworkValue( "RainbowCar", nil )
                Chat:Send( args.player, self.prefix, Color.White, "Переливание цветов для транспорта отключено.", Color.Pink )
            else
                args.player:SetNetworkValue( "RainbowCar", 1 )
                Chat:Send( args.player, self.prefix, Color.White, "Переливание цветов для транспорта включено.", Color.Pink )
            end
        end
    end
end

function RainbowCars:PreTick( args )
    for p in Server:GetPlayers() do
        if p:GetValue( "RainbowCar" ) then
            if p:InVehicle() then
                local h = ( 0.01 * self.rT:GetMilliseconds() - string.len( p:GetName() ) ) * 10
                local color = Color.FromHSV( h % 360, 1, 1 )
                p:GetVehicle():SetColors( color, color )
            end
        end
    end
end

rainbowcars = RainbowCars()