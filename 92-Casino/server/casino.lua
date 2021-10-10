class 'CoinFlip'

function CoinFlip:__init()
    Network:Subscribe( "Coinflip", self, self.Coinflip )

    self.cmd = "/cflip"
    self.prefix = "[Монетка] "
    self.chance = 30
    self.limit = 1000
end

function CoinFlip:Coinflip( args, sender )
    local amount = args.stavka
    if amount == nil then
        sender:SendChatMessage( self.prefix, Color.White, "Это недействительная сумма денег для ставки!", Color.DarkGray )
        return false
    end

    if amount <= 0 then
        Network:Send( sender, "TextBox", { text = "Это недействительная сумма денег для ставки!" } )
        return false
    end

    if amount > self.limit then
        Network:Send( sender, "TextBox", { text = "Вы не можете поставить более $" .. self.limit .. "!" } )
        return false
    end

    if sender:GetMoney() < amount then 
        Network:Send( sender, "TextBox", { text = "У вас недостаточно денег для ставки :c" } )
        return false
    end

    if math.random( 0, 100 ) < self.chance then
        sender:SetMoney( sender:GetMoney() + amount * 2 )
        Network:Send( sender, "TextBox", { text = "Вы выиграли " .. "$" .. formatNumber( amount * 2 ) .. "!", color = Color.Lime } )
    else
        sender:SetMoney( sender:GetMoney() - amount )
        Network:Send( sender, "TextBox", { text = "Вы проиграли " .. "$" .. formatNumber( amount ) .. "!", color = Color.Red } )
    end
end

coinflip = CoinFlip()