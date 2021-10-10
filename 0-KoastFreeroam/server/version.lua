class 'Version'

function Version:__init()
    Events:Subscribe( "ServerStart", self, self.ServerStart )
    Events:Subscribe( "PlayerJoin", self, self.PlayerJoin )
    Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )

    self.ver = "43.1"
    self.build = "250921.0"
end

function Version:ServerStart()
    print( "KMod Version: " .. self.ver .. " | Build: " .. self.build )
    Events:Fire( "ToDiscordConsole", { text = "[Status] KMod Version: " .. self.ver .. " | Build: " .. self.build } )
end

function Version:PlayerJoin( args )
    args.player:SetNetworkValue( "KoastBuild", self.ver )
end

function Version:ModuleLoad( args )
    for p in Server:GetPlayers() do
        if p:GetValue( "KoastBuild" ) then
            if p:GetValue( "KoastBuild" ) ~= self.ver then
                p:SetNetworkValue( "KoastBuild", self.ver )
            end
        end
    end
end

version = Version()