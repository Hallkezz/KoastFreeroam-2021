class 'Abilities'

function Abilities:__init()
    self.actions = {
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[11] = true,
		[12] = true,
		[13] = true,
		[14] = true,
		[17] = true,
		[18] = true,
		[105] = true,
		[137] = true,
		[138] = true,
		[139] = true,
		[16] = true
	}

    self.wingsuitIMG = Image.Create( AssetLocation.Resource, "Wingsuit" )
    self.boostIMG = Image.Create( AssetLocation.Resource, "Boost" )
    self.moneyBonusIMG = Image.Create( AssetLocation.Resource, "MoneyBonus" )
    self.moreC4IMG = Image.Create( AssetLocation.Resource, "MoreC4" )
    self.superNuclearBombIMG = Image.Create( AssetLocation.Resource, "SuperNuclearBomb" )
    self.longerGrappleIMG = Image.Create( AssetLocation.Resource, "LongerGrapple" )
    self.jesusModeIMG = Image.Create( AssetLocation.Resource, "JesusMode" )

    self.active = false

    self.boostValue_1 = 1
    self.boostValue_2 = 2
    self.boostValue_3 = 3

    self.moreC4Value_5 = 5
    self.moreC4Value_8 = 8
    self.moreC4Value_10 = 10
    self.moreC4Value_15 = 15

    self.GrappleLongerValue_1 = 150
    self.GrappleLongerValue_2 = 180
    self.GrappleLongerValue_3 = 200
    self.GrappleLongerValue_4 = 250

	if LocalPlayer:GetValue( "Lang" ) and LocalPlayer:GetValue( "Lang" ) == "ENG" then
		self:Lang()
	else
        self.needed_txt = "Цена"
        self.unlocked_txt = "Приобретено"
        self.morec4_txt = "Увеличение кол-во C4"
        self.jesusmode_txt = "Режим Иисуса"
	end

    self.unlockedC = Color( 0, 255, 0, 30 )

    self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.4, 0.5 ) )
	self.window:SetMinimumSize( Vector2( 500, 442 ) )
	self.window:SetPositionRel( Vector2( 0.7, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetTitle( "▧ Способности" )
    self.window:SetVisible( self.active )
    self.window:Subscribe( "WindowClosed", self, self.WindowClosed )

    self.toplabel = Label.Create( self.window )
    self.toplabel:SetSize( Vector2( 0, 30 ) )
    self.toplabel:SetMargin( Vector2( 0, 0 ), Vector2( 0, 0 ) )
    self.toplabel:SetDock( GwenPosition.Top )

    self.toplabelbk = Label.Create( self.toplabel )
    self.toplabelbk:SetDock( GwenPosition.Fill )

    self.money_text = Label.Create( self.toplabelbk )
    self.money_text:SetDock( GwenPosition.Left )
    self.money_text:SetMargin( Vector2( 10, 5 ), Vector2( 0, 0 ) )
    self.money_text:SetText( "Баланс: $" .. formatNumber( LocalPlayer:GetMoney() ) )
    self.money_text:SetTextColor( Color( 251, 184, 41 ) )
    self.money_text:SetTextSize( 18 )
    self.money_text:SizeToContents()

    self.mainlabel = Label.Create( self.window )
    self.mainlabel:SetDock( GwenPosition.Fill )

    --[[self.clearbutton = Button.Create( self.mainlabel )
    self.clearbutton:SetSize( Vector2( 50, 50 ) )
    self.clearbutton:SetDock( GwenPosition.Bottom )
    self.clearbutton:Subscribe( "Press", self, self.Clear )--]]

    self.wingsuitbutton = Button.Create( self.mainlabel )
    self.wingsuitbutton:SetSize( Vector2( 50, 50 ) )
    self.wingsuitbutton:SetPosition( Vector2( 10, 5 ) )
    self.wingsuitbutton:Subscribe( "Press", self, self.WingsuitUnlocker )

    self.wingsuitbutton.unlockstats = Rectangle.Create( self.wingsuitbutton )
    self.wingsuitbutton.unlockstats:SetDock( GwenPosition.Fill )
    self.wingsuitbutton.unlockstats:SetColor( self.unlockedC )

    self.wingsuitbutton.image = ImagePanel.Create( self.wingsuitbutton )
    self.wingsuitbutton.image:SetDock( GwenPosition.Fill )
    self.wingsuitbutton.image:SetImage( self.wingsuitIMG )


    self.boost_1button = Button.Create( self.mainlabel )
    self.boost_1button:SetSize( Vector2( 50, 50 ) )
    self.boost_1button:SetPosition( Vector2( self.wingsuitbutton:GetPosition().x + 60 , 5 ) )
    self.boost_1button:Subscribe( "Press", self, self.BoostUnlocker )

    self.boost_1button.unlockstats = Rectangle.Create( self.boost_1button )
    self.boost_1button.unlockstats:SetDock( GwenPosition.Fill )
    self.boost_1button.unlockstats:SetColor( self.unlockedC )

    self.boost_1button.image = ImagePanel.Create( self.boost_1button )
    self.boost_1button.image:SetDock( GwenPosition.Fill )
    self.boost_1button.image:SetImage( self.boostIMG )

    self.boost_2button = Button.Create( self.mainlabel )
    self.boost_2button:SetSize( Vector2( 50, 50 ) )
    self.boost_2button:SetPosition( Vector2( self.wingsuitbutton:GetPosition().x + 60 , self.boost_1button:GetPosition().y + 55 ) )
    self.boost_2button:SetVisible( false )
    self.boost_2button:Subscribe( "Press", self, self.BoostUnlocker )

    self.boost_2button.unlockstats = Rectangle.Create( self.boost_2button )
    self.boost_2button.unlockstats:SetDock( GwenPosition.Fill )
    self.boost_2button.unlockstats:SetColor( self.unlockedC )
    self.boost_2button.unlockstats:SetVisible( false )

    self.boost_2button.image = ImagePanel.Create( self.boost_2button )
    self.boost_2button.image:SetDock( GwenPosition.Fill )
    self.boost_2button.image:SetImage( self.boostIMG )

    self.boost_3button = Button.Create( self.mainlabel )
    self.boost_3button:SetSize( Vector2( 50, 50 ) )
    self.boost_3button:SetPosition( Vector2( self.wingsuitbutton:GetPosition().x + 60 , self.boost_2button:GetPosition().y + 55 ) )
    self.boost_3button:SetVisible( false )
    self.boost_3button:Subscribe( "Press", self, self.BoostUnlocker )

    self.boost_3button.unlockstats = Rectangle.Create( self.boost_3button )
    self.boost_3button.unlockstats:SetDock( GwenPosition.Fill )
    self.boost_3button.unlockstats:SetColor( self.unlockedC )
    self.boost_3button.unlockstats:SetVisible( false )

    self.boost_3button.image = ImagePanel.Create( self.boost_3button )
    self.boost_3button.image:SetDock( GwenPosition.Fill )
    self.boost_3button.image:SetImage( self.boostIMG )


    self.bonusmoneybutton = Button.Create( self.mainlabel )
    self.bonusmoneybutton:SetSize( Vector2( 50, 50 ) )
    self.bonusmoneybutton:SetPosition( Vector2( self.boost_1button:GetPosition().x + 60 , 5 ) )
    self.bonusmoneybutton:Subscribe( "Press", self, self.MoneyBonusUnlocker )

    self.bonusmoneybutton.unlockstats = Rectangle.Create( self.bonusmoneybutton )
    self.bonusmoneybutton.unlockstats:SetDock( GwenPosition.Fill )
    self.bonusmoneybutton.unlockstats:SetColor( self.unlockedC )

    self.bonusmoneybutton.image = ImagePanel.Create( self.bonusmoneybutton )
    self.bonusmoneybutton.image:SetDock( GwenPosition.Fill )
    self.bonusmoneybutton.image:SetImage( self.moneyBonusIMG )


    self.moreC4_5button = Button.Create( self.mainlabel )
    self.moreC4_5button:SetSize( Vector2( 50, 50 ) )
    self.moreC4_5button:SetPosition( Vector2( self.bonusmoneybutton:GetPosition().x + 60 , 5 ) )
    self.moreC4_5button:Subscribe( "Press", self, self.MoreC4Unlocker )

    self.moreC4_5button.unlockstats = Rectangle.Create( self.moreC4_5button )
    self.moreC4_5button.unlockstats:SetDock( GwenPosition.Fill )
    self.moreC4_5button.unlockstats:SetColor( self.unlockedC )

    self.moreC4_5button.image = ImagePanel.Create( self.moreC4_5button )
    self.moreC4_5button.image:SetDock( GwenPosition.Fill )
    self.moreC4_5button.image:SetImage( self.moreC4IMG )

    self.moreC4_8button = Button.Create( self.mainlabel )
    self.moreC4_8button:SetSize( Vector2( 50, 50 ) )
    self.moreC4_8button:SetPosition( Vector2( self.bonusmoneybutton:GetPosition().x + 60 , self.moreC4_5button:GetPosition().y + 55 ) )
    self.moreC4_8button:SetVisible( false )
    self.moreC4_8button:Subscribe( "Press", self, self.MoreC4Unlocker )

    self.moreC4_8button.unlockstats = Rectangle.Create( self.moreC4_8button )
    self.moreC4_8button.unlockstats:SetDock( GwenPosition.Fill )
    self.moreC4_8button.unlockstats:SetColor( self.unlockedC )
    self.moreC4_8button.unlockstats:SetVisible( false )

    self.moreC4_8button.image = ImagePanel.Create( self.moreC4_8button )
    self.moreC4_8button.image:SetDock( GwenPosition.Fill )
    self.moreC4_8button.image:SetImage( self.moreC4IMG )

    self.moreC4_10button = Button.Create( self.mainlabel )
    self.moreC4_10button:SetSize( Vector2( 50, 50 ) )
    self.moreC4_10button:SetPosition( Vector2( self.bonusmoneybutton:GetPosition().x + 60 , self.moreC4_8button:GetPosition().y + 55 ) )
    self.moreC4_10button:SetVisible( false )
    self.moreC4_10button:Subscribe( "Press", self, self.MoreC4Unlocker )

    self.moreC4_10button.unlockstats = Rectangle.Create( self.moreC4_10button )
    self.moreC4_10button.unlockstats:SetDock( GwenPosition.Fill )
    self.moreC4_10button.unlockstats:SetColor( self.unlockedC )
    self.moreC4_10button.unlockstats:SetVisible( false )

    self.moreC4_10button.image = ImagePanel.Create( self.moreC4_10button )
    self.moreC4_10button.image:SetDock( GwenPosition.Fill )
    self.moreC4_10button.image:SetImage( self.moreC4IMG )


    self.moreC4_15button = Button.Create( self.mainlabel )
    self.moreC4_15button:SetSize( Vector2( 50, 50 ) )
    self.moreC4_15button:SetPosition( Vector2( self.bonusmoneybutton:GetPosition().x + 60 , self.moreC4_10button:GetPosition().y + 55 ) )
    self.moreC4_15button:SetVisible( false )
    self.moreC4_15button:Subscribe( "Press", self, self.MoreC4Unlocker )

    self.moreC4_15button.unlockstats = Rectangle.Create( self.moreC4_15button )
    self.moreC4_15button.unlockstats:SetDock( GwenPosition.Fill )
    self.moreC4_15button.unlockstats:SetColor( self.unlockedC )
    self.moreC4_15button.unlockstats:SetVisible( false )

    self.moreC4_15button.image = ImagePanel.Create( self.moreC4_15button )
    self.moreC4_15button.image:SetDock( GwenPosition.Fill )
    self.moreC4_15button.image:SetImage( self.moreC4IMG )


    self.supernuclearbombbutton = Button.Create( self.mainlabel )
    self.supernuclearbombbutton:SetSize( Vector2( 50, 50 ) )
    self.supernuclearbombbutton:SetPosition( Vector2( self.moreC4_5button:GetPosition().x + 60 , 5 ) )
    self.supernuclearbombbutton:Subscribe( "Press", self, self.SuperNuclearBombUnlocker )

    self.supernuclearbombbutton.unlockstats = Rectangle.Create( self.supernuclearbombbutton )
    self.supernuclearbombbutton.unlockstats:SetDock( GwenPosition.Fill )
    self.supernuclearbombbutton.unlockstats:SetColor( self.unlockedC )

    self.supernuclearbombbutton.image = ImagePanel.Create( self.supernuclearbombbutton )
    self.supernuclearbombbutton.image:SetDock( GwenPosition.Fill )
    self.supernuclearbombbutton.image:SetImage( self.superNuclearBombIMG )


    self.longergrapple_150button = Button.Create( self.mainlabel )
    self.longergrapple_150button:SetSize( Vector2( 50, 50 ) )
    self.longergrapple_150button:SetPosition( Vector2( self.supernuclearbombbutton:GetPosition().x + 60 , 5 ) )
    self.longergrapple_150button:Subscribe( "Press", self, self.LongerGrappleUnlocker )

    self.longergrapple_150button.unlockstats = Rectangle.Create( self.longergrapple_150button )
    self.longergrapple_150button.unlockstats:SetDock( GwenPosition.Fill )
    self.longergrapple_150button.unlockstats:SetColor( self.unlockedC )

    self.longergrapple_150button.image = ImagePanel.Create( self.longergrapple_150button )
    self.longergrapple_150button.image:SetDock( GwenPosition.Fill )
    self.longergrapple_150button.image:SetImage( self.longerGrappleIMG )

    self.longergrapple_200button = Button.Create( self.mainlabel )
    self.longergrapple_200button:SetSize( Vector2( 50, 50 ) )
    self.longergrapple_200button:SetPosition( Vector2( self.supernuclearbombbutton:GetPosition().x + 60 , self.longergrapple_150button:GetPosition().y + 55 ) )
    self.longergrapple_200button:SetVisible( false )
    self.longergrapple_200button:Subscribe( "Press", self, self.LongerGrappleUnlocker )

    self.longergrapple_200button.unlockstats = Rectangle.Create( self.longergrapple_200button )
    self.longergrapple_200button.unlockstats:SetDock( GwenPosition.Fill )
    self.longergrapple_200button.unlockstats:SetColor( self.unlockedC )
    self.longergrapple_200button.unlockstats:SetVisible( false )

    self.longergrapple_200button.image = ImagePanel.Create( self.longergrapple_200button )
    self.longergrapple_200button.image:SetDock( GwenPosition.Fill )
    self.longergrapple_200button.image:SetImage( self.longerGrappleIMG )

    self.longergrapple_350button = Button.Create( self.mainlabel )
    self.longergrapple_350button:SetSize( Vector2( 50, 50 ) )
    self.longergrapple_350button:SetPosition( Vector2( self.supernuclearbombbutton:GetPosition().x + 60 , self.longergrapple_200button:GetPosition().y + 55 ) )
    self.longergrapple_350button:SetVisible( false )
    self.longergrapple_350button:Subscribe( "Press", self, self.LongerGrappleUnlocker )

    self.longergrapple_350button.unlockstats = Rectangle.Create( self.longergrapple_350button )
    self.longergrapple_350button.unlockstats:SetDock( GwenPosition.Fill )
    self.longergrapple_350button.unlockstats:SetColor( self.unlockedC )
    self.longergrapple_350button.unlockstats:SetVisible( false )

    self.longergrapple_350button.image = ImagePanel.Create( self.longergrapple_350button )
    self.longergrapple_350button.image:SetDock( GwenPosition.Fill )
    self.longergrapple_350button.image:SetImage( self.longerGrappleIMG )

    self.longergrapple_500button = Button.Create( self.mainlabel )
    self.longergrapple_500button:SetSize( Vector2( 50, 50 ) )
    self.longergrapple_500button:SetPosition( Vector2( self.supernuclearbombbutton:GetPosition().x + 60 , self.longergrapple_350button:GetPosition().y + 55 ) )
    self.longergrapple_500button:SetVisible( false )
    self.longergrapple_500button:Subscribe( "Press", self, self.LongerGrappleUnlocker )

    self.longergrapple_500button.unlockstats = Rectangle.Create( self.longergrapple_500button )
    self.longergrapple_500button.unlockstats:SetDock( GwenPosition.Fill )
    self.longergrapple_500button.unlockstats:SetColor( self.unlockedC )
    self.longergrapple_500button.unlockstats:SetVisible( false )

    self.longergrapple_500button.image = ImagePanel.Create( self.longergrapple_500button )
    self.longergrapple_500button.image:SetDock( GwenPosition.Fill )
    self.longergrapple_500button.image:SetImage( self.longerGrappleIMG )


    self.jesusmode_button = Button.Create( self.mainlabel )
    self.jesusmode_button:SetSize( Vector2( 50, 50 ) )
    self.jesusmode_button:SetPosition( Vector2( self.longergrapple_150button:GetPosition().x + 60 , 5 ) )
    self.jesusmode_button:Subscribe( "Press", self, self.JesusModeUnlocker )

    self.jesusmode_button.unlockstats = Rectangle.Create( self.jesusmode_button )
    self.jesusmode_button.unlockstats:SetDock( GwenPosition.Fill )
    self.jesusmode_button.unlockstats:SetColor( self.unlockedC )

    self.jesusmode_button.image = ImagePanel.Create( self.jesusmode_button )
    self.jesusmode_button.image:SetDock( GwenPosition.Fill )
    self.jesusmode_button.image:SetImage( self.jesusModeIMG )

    Events:Subscribe( "Lang", self, self.Lang )
    Events:Subscribe( "OpenAbitiliesMenu", self, self.OpenAbitiliesMenu )
    Events:Subscribe( "CloseAbitiliesMenu", self, self.CloseAbitiliesMenu )
    Events:Subscribe( "LocalPlayerMoneyChange", self, self.LocalPlayerMoneyChange )
end

function Abilities:Lang()
    if self.window then
        self.window:SetTitle( "▧ Abilities" )
    end
    self.needed_txt = "Price"
    self.unlocked_txt = "Unlocked"
    self.morec4_txt = "More C4"
    self.jesusmode_txt = "Jesus mode"
end

function Abilities:Clear()
    Network:Send( "Clear" )
end

function Abilities:WingsuitUnlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "WingsuitUnlock" )

    self.wingsuitbutton.unlockstats:SetToolTip( "Вингсьют ( " .. self.unlocked_txt .. " )" )
    self.wingsuitbutton.unlockstats:SetVisible( true )

    Events:Fire( "OpenWhatsNew", { titletext = "Вингсьют", text = "Используйте клавишу 'Q' находясь в свободном полете или на парашюте, чтобы раскрыть вингсьют." } )
end

function Abilities:BoostUnlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "BoostUnlock" )

    if not LocalPlayer:GetValue( "Boost" ) then
        self.boost_1button.unlockstats:SetToolTip( "Ускорение для наземного транспорта ( " .. self.unlocked_txt .. " )" )
        self.boost_1button.unlockstats:SetVisible( true )

        self.boost_2button:SetToolTip( "Ускорение для морского транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_2 ) .. " )" )
        self.boost_2button:SetVisible( true )

        Events:Fire( "OpenWhatsNew", { titletext = "Ускорение для наземного транспорта", text = "Используйте клавишу 'Shift', чтобы воспользоваться супер-пупер ускорением." } )
    elseif LocalPlayer:GetValue( "Boost" ) == self.boostValue_1 then
        self.boost_2button.unlockstats:SetToolTip( "Ускорение для морского транспорта ( " .. self.unlocked_txt .. " )" )
        self.boost_2button.unlockstats:SetVisible( true )

        self.boost_3button:SetToolTip( "Ускорение для воздушного транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_3 ) .. " )" )
        self.boost_3button:SetVisible( true )
    elseif LocalPlayer:GetValue( "Boost" ) == self.boostValue_2 then
        self.boost_3button.unlockstats:SetToolTip( "Ускорение для воздушного транспорта ( " .. self.unlocked_txt .. " )" )
        self.boost_3button.unlockstats:SetVisible( true )

        Events:Fire( "OpenWhatsNew", { titletext = "Ускорение для воздушного транспорта", text = "Используйте клавишу 'Q', чтобы воспользоваться супер-пупер ускорением." } )
    end
end

function Abilities:MoneyBonusUnlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "MoneyBonusUnlock" )

    self.bonusmoneybutton.unlockstats:SetToolTip( "Денежный бонус ( " .. self.unlocked_txt .. " )" )
    self.bonusmoneybutton.unlockstats:SetVisible( true )

    Events:Fire( "OpenWhatsNew", { titletext = "Денежный бонус", text = "                                              Поздравляем! Теперь вам доступен денежный бонус.\nДенежный бонус выдается каждый час игры. Чтобы его поулчить - зайдите в меню сервера." } )
end

function Abilities:MoreC4Unlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "MoreC4Unlock" )

    if not LocalPlayer:GetValue( "MoreC4" ) then
        self.moreC4_5button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_5 .. " штук) ( " .. self.unlocked_txt .. " )" )
        self.moreC4_5button.unlockstats:SetVisible( true )

        self.moreC4_8button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_8 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_8 ) .. " )" )
        self.moreC4_8button:SetVisible( true )
    elseif LocalPlayer:GetValue( "MoreC4" ) == self.moreC4Value_5 then
        self.moreC4_8button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_8 .. " штук) ( " .. self.unlocked_txt .. " )" )
        self.moreC4_8button.unlockstats:SetVisible( true )

        self.moreC4_10button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_10 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_10 ) .. " )" )
        self.moreC4_10button:SetVisible( true )
    elseif LocalPlayer:GetValue( "MoreC4" ) == self.moreC4Value_8 then
        self.moreC4_10button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_10 .. " штук) ( " .. self.unlocked_txt .. " )" )
        self.moreC4_10button.unlockstats:SetVisible( true )

        self.moreC4_15button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_15 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_15 ) .. " )" )
        self.moreC4_15button:SetVisible( true )
    elseif LocalPlayer:GetValue( "MoreC4" ) == self.moreC4Value_10 then
        self.moreC4_15button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_15 .. " штук) ( " .. self.unlocked_txt .. " )" )
        self.moreC4_15button.unlockstats:SetVisible( true )
    end
end

function Abilities:UpdateButtons()
    if LocalPlayer:GetMoney() >= Prices.Wingsuit then
        self.wingsuitbutton:SetEnabled( true )
    else
        self.wingsuitbutton:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.Boost_1 then
        self.boost_1button:SetEnabled( true )
    else
        self.boost_1button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.Boost_2 then
        self.boost_2button:SetEnabled( true )
    else
        self.boost_2button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.Boost_3 then
        self.boost_3button:SetEnabled( true )
    else
        self.boost_3button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.BonusMoney then
        self.bonusmoneybutton:SetEnabled( true )
    else
        self.bonusmoneybutton:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.MoreC4_5 then
        self.moreC4_5button:SetEnabled( true )
    else
        self.moreC4_5button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.MoreC4_8 then
        self.moreC4_8button:SetEnabled( true )
    else
        self.moreC4_8button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.MoreC4_10 then
        self.moreC4_10button:SetEnabled( true )
    else
        self.moreC4_10button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.MoreC4_15 then
        self.moreC4_15button:SetEnabled( true )
    else
        self.moreC4_15button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.SuperNuclearBomb then
        self.supernuclearbombbutton:SetEnabled( true )
    else
        self.supernuclearbombbutton:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.LongerGrapple_150 then
        self.longergrapple_150button:SetEnabled( true )
    else
        self.longergrapple_150button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.LongerGrapple_200 then
        self.longergrapple_200button:SetEnabled( true )
    else
        self.longergrapple_200button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.LongerGrapple_350 then
        self.longergrapple_350button:SetEnabled( true )
    else
        self.longergrapple_350button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.LongerGrapple_500 then
        self.longergrapple_500button:SetEnabled( true )
    else
        self.longergrapple_500button:SetEnabled( false )
    end

    if LocalPlayer:GetMoney() >= Prices.JesusMode then
        self.jesusmode_button:SetEnabled( true )
    else
        self.jesusmode_button:SetEnabled( false )
    end
end

function Abilities:SuperNuclearBombUnlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "SuperNuclearBombUnlock" )

    self.supernuclearbombbutton.unlockstats:SetToolTip( "СУПЕР Ядерная граната ( " .. self.unlocked_txt .. " )" )
    self.supernuclearbombbutton.unlockstats:SetVisible( true )

    Events:Fire( "OpenWhatsNew", { titletext = "СУПЕР Ядерная граната", text = "Попробуйте пролистать список гранат, вы обязательно там её найдете :)\n              Используйте клавишу 'G', чтобы пролистать список гранат." } )
end

function Abilities:LongerGrappleUnlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "LongerGrappleUnlock" )

    if not LocalPlayer:GetValue( "LongerGrapple" ) then
        self.longergrapple_150button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_1 .. " м) ( " .. self.unlocked_txt .. " )" )
        self.longergrapple_150button.unlockstats:SetVisible( true )

        self.longergrapple_200button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_2 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_200 ) .. " )" )
        self.longergrapple_200button:SetVisible( true )
    elseif LocalPlayer:GetValue( "LongerGrapple" ) == self.GrappleLongerValue_1 then
        self.longergrapple_200button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_2 .. " м) ( " .. self.unlocked_txt .. " )" )
        self.longergrapple_200button.unlockstats:SetVisible( true )

        self.longergrapple_350button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_3 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_350 ) .. " )" )
        self.longergrapple_350button:SetVisible( true )
    elseif LocalPlayer:GetValue( "LongerGrapple" ) == self.GrappleLongerValue_2 then
        self.longergrapple_350button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_3 .. " м) ( " .. self.unlocked_txt .. " )" )
        self.longergrapple_350button.unlockstats:SetVisible( true )

        self.longergrapple_500button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_4 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_500 ) .. " )" )
        self.longergrapple_500button:SetVisible( true )
    elseif LocalPlayer:GetValue( "LongerGrapple" ) == self.GrappleLongerValue_3 then
        self.longergrapple_500button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_4 .. " м) ( " .. self.unlocked_txt .. " )" )
        self.longergrapple_500button.unlockstats:SetVisible( true )
    end
end

function Abilities:JesusModeUnlocker()
    local sound = ClientSound.Create(AssetLocation.Game, {
        bank_id = 20,
        sound_id = 16,
        position = Camera:GetPosition(),
        angle = Camera:GetAngle()
    })

    sound:SetParameter(0,0.75)
    Network:Send( "JesusModeUnlock" )

    self.jesusmode_button.unlockstats:SetToolTip( self.jesusmode_txt .. " ( " .. self.unlocked_txt .. " )" )
    self.jesusmode_button.unlockstats:SetVisible( true )

    Events:Fire( "OpenWhatsNew", { titletext = "Режим Иисуса", text = "                Поздравляем, теперь вы можете ходить и ездить по воде!\nЗайдите в меню сервера, чтобы включить или отключить режим Иисуса." } )
end

function Abilities:Render()
    if self.window then
        self:UpdateButtons()
    end

    local is_visible = self.active and (Game:GetState() == GUIState.Game)

    if self.window:GetVisible() ~= is_visible then
        self.window:SetVisible( is_visible )
    end

    if self.active then
        Mouse:SetVisible( true )
    end
end

function Abilities:OpenAbitiliesMenu()
    self:Open()
end

function Abilities:CloseAbitiliesMenu()
	if self.window:GetVisible() == true then
        self:SetWindowVisible( false )
        if self.RenderEvent then
            Events:Unsubscribe( self.RenderEvent )
            self.RenderEvent = nil
        end

        if self.LocalPlayerInputEvent then
            Events:Unsubscribe( self.LocalPlayerInputEvent )
            self.LocalPlayerInputEvent = nil
        end
	end
end

function Abilities:Open()
    self:SetWindowVisible( not self.active )

    if self.active then
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 382,

			position = Camera:GetPosition(),
			angle = Angle()
		})

        if LocalPlayer:GetValue( "SystemFonts" ) then
            self.money_text:SetFont( AssetLocation.SystemFont, "Impact" )
        end

        if not self.RenderEvent then
            self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
        end

        if not self.LocalPlayerInputEvent then
            self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
        end

        if LocalPlayer:GetValue( "Lang" ) then
			if LocalPlayer:GetValue( "Lang" ) == "РУС" then
                self.money_text:SetText( "Баланс: $" .. formatNumber( LocalPlayer:GetMoney() ) )
                self.money_text:SizeToContents()
            else
                self.money_text:SetText( "Money: $" .. formatNumber( LocalPlayer:GetMoney() ) )
                self.money_text:SizeToContents()
            end
        end

        if LocalPlayer:GetValue( "Wingsuit" ) then
            self.wingsuitbutton.unlockstats:SetToolTip( "Вингсьют ( " .. self.unlocked_txt .. " )" )
            self.wingsuitbutton.unlockstats:SetVisible( true )
        else
            self.wingsuitbutton:SetToolTip( "Вингсьют ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Wingsuit ) .. " )" )
            self.wingsuitbutton.unlockstats:SetVisible( false )
        end

        if LocalPlayer:GetValue( "Boost" ) then
            self.boost_1button.unlockstats:SetToolTip( "Ускорение для наземного транспорта ( " .. self.unlocked_txt .. " )" )
            self.boost_1button.unlockstats:SetVisible( true )

            if LocalPlayer:GetValue( "Boost" ) == self.boostValue_1 then
                self.boost_2button:SetToolTip( "Ускорение для морского транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_2 ) .. " )" )
                self.boost_2button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "Boost" ) >= self.boostValue_2 then
                self.boost_2button.unlockstats:SetToolTip( "Ускорение для морского транспорта ( " .. self.unlocked_txt .. " )" )
                self.boost_2button:SetVisible( true )
                self.boost_2button.unlockstats:SetVisible( true )
            end

            if LocalPlayer:GetValue( "Boost" ) == self.boostValue_2 then
                self.boost_3button:SetToolTip( "Ускорение для воздушного транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_3 ) .. " )" )
                self.boost_3button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "Boost" ) >= self.boostValue_3 then
                self.boost_3button.unlockstats:SetToolTip( "Ускорение для воздушного транспорта ( " .. self.unlocked_txt .. " )" )
                self.boost_3button:SetVisible( true )
                self.boost_3button.unlockstats:SetVisible( true )
            end
        else
            self.boost_1button:SetToolTip( "Ускорение для наземного транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_1 ) .. " )" )
            self.boost_1button.unlockstats:SetVisible( false )

            self.boost_2button.unlockstats:SetToolTip( "Ускорение для морского транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_2 ) .. " )" )
            self.boost_2button:SetVisible( false )
            self.boost_2button.unlockstats:SetVisible( false )

            self.boost_3button.unlockstats:SetToolTip( "Ускорение для воздушного транспорта ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.Boost_3 ) .. " )" )
            self.boost_3button:SetVisible( false )
            self.boost_3button.unlockstats:SetVisible( false )
        end

        if LocalPlayer:GetValue( "MoneyBonus" ) then
            self.bonusmoneybutton.unlockstats:SetToolTip( "Денежный бонус ( " .. self.unlocked_txt .. " )" )
            self.bonusmoneybutton.unlockstats:SetVisible( true )
        else
            self.bonusmoneybutton:SetToolTip( "Денежный бонус ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.BonusMoney ) .. " )" )
            self.bonusmoneybutton.unlockstats:SetVisible( false )
        end

        if LocalPlayer:GetValue( "MoreC4" ) then
            self.moreC4_5button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_5 .. " штук) ( " .. self.unlocked_txt .. " )" )
            self.moreC4_5button.unlockstats:SetVisible( true )

            if LocalPlayer:GetValue( "MoreC4" ) == self.moreC4Value_5 then
                self.moreC4_8button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_8 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_8 ) .. " )" )
                self.moreC4_8button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "MoreC4" ) >= self.moreC4Value_8 then
                self.moreC4_8button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_8 .." штук) ( " .. self.unlocked_txt .. " )" )
                self.moreC4_8button:SetVisible( true )
                self.moreC4_8button.unlockstats:SetVisible( true )
            end

            if LocalPlayer:GetValue( "MoreC4" ) == self.moreC4Value_8 then
                self.moreC4_10button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_10 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_10 ) .. " )" )
                self.moreC4_10button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "MoreC4" ) >= self.moreC4Value_10 then
                self.moreC4_10button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_10 .." штук) ( " .. self.unlocked_txt .. " )" )
                self.moreC4_10button:SetVisible( true )
                self.moreC4_10button.unlockstats:SetVisible( true )
            end

            if LocalPlayer:GetValue( "MoreC4" ) == self.moreC4Value_10 then
                self.moreC4_15button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_15 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_15 ) .. " )" )
                self.moreC4_15button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "MoreC4" ) >= self.moreC4Value_15 then
                self.moreC4_15button.unlockstats:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_15 .." штук) ( " .. self.unlocked_txt .. " )" )
                self.moreC4_15button:SetVisible( true )
                self.moreC4_15button.unlockstats:SetVisible( true )
            end
        else
            self.moreC4_5button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_5 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_5 ) .. " )" )
            self.moreC4_5button.unlockstats:SetVisible( false )

            self.moreC4_8button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_8 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_8 ) .. " )" )
            self.moreC4_8button:SetVisible( false )
            self.moreC4_8button.unlockstats:SetVisible( false )

            self.moreC4_10button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_10 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_10 ) .. " )" )
            self.moreC4_10button:SetVisible( false )
            self.moreC4_10button.unlockstats:SetVisible( false )

            self.moreC4_15button:SetToolTip( self.morec4_txt .. " (" .. self.moreC4Value_15 .. " штук) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.MoreC4_15 ) .. " )" )
            self.moreC4_15button:SetVisible( false )
            self.moreC4_15button.unlockstats:SetVisible( false )
        end

        if LocalPlayer:GetValue( "SuperNuclearBomb" ) then
            self.supernuclearbombbutton.unlockstats:SetToolTip( "СУПЕР Ядерная граната ( " .. self.unlocked_txt .. " )" )
            self.supernuclearbombbutton.unlockstats:SetVisible( true )
        else
            self.supernuclearbombbutton:SetToolTip( "СУПЕР Ядерная граната ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.SuperNuclearBomb ) .. " )" )
            self.supernuclearbombbutton.unlockstats:SetVisible( false )
        end

        if LocalPlayer:GetValue( "LongerGrapple" ) then
            self.longergrapple_150button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_1 .. " м) ( " .. self.unlocked_txt .. " )" )
            self.longergrapple_150button.unlockstats:SetVisible( true )

            if LocalPlayer:GetValue( "LongerGrapple" ) == self.GrappleLongerValue_1 then
                self.longergrapple_200button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_2 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_200 ) .. " )" )
                self.longergrapple_200button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "LongerGrapple" ) >= self.GrappleLongerValue_2 then
                self.longergrapple_200button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_2 .." м) ( " .. self.unlocked_txt .. " )" )
                self.longergrapple_200button:SetVisible( true )
                self.longergrapple_200button.unlockstats:SetVisible( true )
            end

            if LocalPlayer:GetValue( "LongerGrapple" ) == self.GrappleLongerValue_2 then
                self.longergrapple_350button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_3 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_350 ) .. " )" )
                self.longergrapple_350button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "LongerGrapple" ) >= self.GrappleLongerValue_3 then
                self.longergrapple_350button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_3 .." м) ( " .. self.unlocked_txt .. " )" )
                self.longergrapple_350button:SetVisible( true )
                self.longergrapple_350button.unlockstats:SetVisible( true )
            end

            if LocalPlayer:GetValue( "LongerGrapple" ) == self.GrappleLongerValue_3 then
                self.longergrapple_500button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_4 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_500 ) .. " )" )
                self.longergrapple_500button:SetVisible( true )
            end

            if LocalPlayer:GetValue( "LongerGrapple" ) >= self.GrappleLongerValue_4 then
                self.longergrapple_500button.unlockstats:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_4 .." м) ( " .. self.unlocked_txt .. " )" )
                self.longergrapple_500button:SetVisible( true )
                self.longergrapple_500button.unlockstats:SetVisible( true )
            end
        else
            self.longergrapple_150button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_1 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_150 ) .. " )" )
            self.longergrapple_150button.unlockstats:SetVisible( false )

            self.longergrapple_200button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_2 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_200 ) .. " )" )
            self.longergrapple_200button:SetVisible( false )
            self.longergrapple_200button.unlockstats:SetVisible( false )

            self.longergrapple_350button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_3 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_350 ) .. " )" )
            self.longergrapple_350button:SetVisible( false )
            self.longergrapple_350button.unlockstats:SetVisible( false )

            self.longergrapple_500button:SetToolTip( "Дальность крюка (" .. self.GrappleLongerValue_4 .. " м) ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.LongerGrapple_500 ) .. " )" )
            self.longergrapple_500button:SetVisible( false )
            self.longergrapple_500button.unlockstats:SetVisible( false )
        end

        if LocalPlayer:GetValue( "JesusModeEnabled" ) then
            self.jesusmode_button.unlockstats:SetToolTip( self.jesusmode_txt .. " ( " .. self.unlocked_txt .. " )" )
            self.jesusmode_button.unlockstats:SetVisible( true )
        else
            self.jesusmode_button:SetToolTip( self.jesusmode_txt .. " ( " .. self.needed_txt .. ": $" .. formatNumber( Prices.JesusMode ) .. " )" )
            self.jesusmode_button.unlockstats:SetVisible( false )
        end
    end
end

function Abilities:UpdateMoneyString( money )
    if money == nil then
        money = LocalPlayer:GetMoney()
    end

    if LocalPlayer:GetValue( "Lang" ) then
        if LocalPlayer:GetValue( "Lang" ) == "РУС" then
            self.money_text:SetText( "Баланс: $" .. formatNumber( money ) )
            self.money_text:SizeToContents()
        else
            self.money_text:SetText( "Money: $" .. formatNumber( money ) )
            self.money_text:SizeToContents()
        end
    end
end

function Abilities:LocalPlayerMoneyChange( args )
    self:UpdateMoneyString( args.new_money )
end

function Abilities:SetWindowVisible( visible )
    if self.active ~= visible then
		self.active = visible
		self.window:SetVisible( visible )
		Mouse:SetVisible( visible )
	end
end

function Abilities:LocalPlayerInput( args )
	if args.input == Action.GuiPause then
        self:CloseAbitiliesMenu()
	end
    if self.actions[args.input] then
        return false
    end
end

function Abilities:WindowClosed()
	if self.window:GetVisible() == true then
        ClientEffect.Create(AssetLocation.Game, {
            effect_id = 383,
    
            position = Camera:GetPosition(),
            angle = Angle()
        })

        self:SetWindowVisible( false )
        if self.RenderEvent then
            Events:Unsubscribe( self.RenderEvent )
            self.RenderEvent = nil
        end

        if self.LocalPlayerInputEvent then
            Events:Unsubscribe( self.LocalPlayerInputEvent )
            self.LocalPlayerInputEvent = nil
        end
	end
end

function formatNumber( amount )
	local formatted = tostring( amount );
	while true do  
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1.%2' );
		if (k==0) then
			break
		end
	end
	return formatted;
end

abilities = Abilities()