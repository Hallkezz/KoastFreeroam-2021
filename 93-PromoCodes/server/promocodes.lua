class 'PromoCodes'

function PromoCodes:__init()
    Events:Subscribe( "ClientModuleLoad", self, self.ClientModuleLoad )
    Network:Subscribe( "GetMoney", self, self.GetMoney )
    Console:Subscribe( "setpromocode", self, self.SetPromocode )
end

function PromoCodes:ClientModuleLoad( args )
    if self.promocode then
        Network:Send( args.player, "SetPromoCode", { promocode = self.promocode } )
    end
end

function PromoCodes:GetMoney( args, sender )
    if self.promocode then
        sender:SetMoney( sender:GetMoney() + 10000 )
        self.promocode = nil
    end
end

function PromoCodes:SetPromocode( args )
    print( "Successfully. PromoCode: " .. args.text )
    Events:Fire( "ToDiscordConsole", { text = "Successfully. PromoCode: " .. args.text } )

    for p in Server:GetPlayers() do
        Network:Send( p, "SetPromoCode", { promocode = args.text } )
    end
    self.promocode = args.text
end

promocodes = PromoCodes()