class 'GameModesMenu'

function GameModesMenu:__init()
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

    self.manhuntimage = Image.Create( AssetLocation.Resource, "ManhuntICO" )
	self.carbattlesimage = Image.Create( AssetLocation.Resource, "CarBattlesICO" )
	self.raceimage = Image.Create( AssetLocation.Resource, "RaceICO" )
	self.tronimage = Image.Create( AssetLocation.Resource, "TronICO" )
	self.kinghillimage = Image.Create( AssetLocation.Resource, "KingHillICO" )
	self.tetrisimage = Image.Create( AssetLocation.Resource, "TetrisICO" )
	self.pongimage = Image.Create( AssetLocation.Resource, "PongICO" )
	self.casinoimage = Image.Create( AssetLocation.Resource, "CasinoICO" )

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "OpenGameModesMenu", self, self.OpenGameModesMenu )
	Events:Subscribe( "CloseGameModesMenu", self, self.CloseGameModesMenu )

    self.resizer_txt = "Черный ниггер"
    self:CreateWindow()
end

function GameModesMenu:Lang()
    self.window:SetTitle( "▧ Minigames" )
	self.mainButton.txtlabel_gm:SetText( "Game Modes:" )
	self.mainButton.hunt:SetText( "Hunt" )
	self.mainButton.hunt:SetToolTip( "Survive and kill other players on a small island." )
	self.mainButton.carbattles:SetText( "Car Battles" )
	self.mainButton.carbattles:SetToolTip( "Fight and survive on cars." )
	self.mainButton.race:SetText( "Race" )
	self.mainButton.race:SetToolTip( "Get first to the finish line among other riders." )
	self.mainButton.tron:SetText( "Tron" )
	self.mainButton.tron:SetToolTip( "Lure other players into your lane to win." )
	self.mainButton.khill:SetText( "King Of The Hill" )
	self.mainButton.khill:SetToolTip( "Get to the top of the hill first to win." )
	self.mainButton.derby:SetText( "Derby" )
	self.mainButton.derby:SetToolTip( "Crush the cars of other players trying to survive on your own." )
	self.mainButton.txtlabel_mg:SetText( "Others:" )
	self.mainButton.tetris:SetText( "Tetris" )
	self.mainButton.tetris:SetToolTip( "Classic tetris." )
	self.mainButton.pong:SetText( "Pong" )
	self.mainButton.pong:SetToolTip( "Gopnik waiting you in pong." )
	self.mainButton.casino:SetText( "Casino" )
	self.mainButton.casino:SetToolTip( "Money gambling." )
end

function GameModesMenu:OpenGameModesMenu( args )
	if Game:GetState() ~= GUIState.Game then return end

    if self.window:GetVisible() then
        self:WindowClosed()
    else
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 382,

			position = Camera:GetPosition(),
			angle = Angle()
		})

        self.window:SetVisible( true )
        Mouse:SetVisible( true )

		self.mainButton.scroll_gm:SetSize( Vector2( self.window:GetSize().x - 15, self.mainButton.hunt:GetHeight() + 25 ) )
		self.mainButton.scroll_mg:SetSize( Vector2( self.window:GetSize().x - 15, self.mainButton.tetris:GetHeight() + 25 ) )

		if LocalPlayer:GetValue( "SystemFonts" ) then
			self.mainButton.hunt:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.carbattles:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.race:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.tron:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.khill:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.derby:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.tetris:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.pong:SetFont( AssetLocation.SystemFont, "Impact" )
			self.mainButton.casino:SetFont( AssetLocation.SystemFont, "Impact" )
		end

        if not self.LocalPlayerInputEvent then
            self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
        end
    end
end

function GameModesMenu:CloseGameModesMenu( args )
	if Game:GetState() ~= GUIState.Game then return end
	if self.window:GetVisible() == true then
		self:WindowClosed()
	end
end

function GameModesMenu:CreateWindow()
    self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.5, 0.5 ) )
	self.window:SetMinimumSize( Vector2( 500, 442 ) )
	self.window:SetPositionRel( Vector2( 0.7, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetTitle( "▧ Развлечения" )
    self.window:SetVisible( false )
    self.window:Subscribe( "WindowClosed", self, self.GameModesMenuClosed )

	-- MOTD area

    self.scroll_control = ScrollControl.Create( self.window )
	self.scroll_control:SetScrollable( false, true )
	self.scroll_control:SetDock( GwenPosition.Fill )

    self.mainButton = {}

	self.mainButton.txtlabel_gm = Label.Create( self.scroll_control )
	self.mainButton.txtlabel_gm:SetText( "Игровые режимы:" )
	self.mainButton.txtlabel_gm:SetDock( GwenPosition.Top )
	self.mainButton.txtlabel_gm:SetMargin( Vector2( 5, 10 ), Vector2( 0, 0 ) )
	self.mainButton.txtlabel_gm:SizeToContents()

	self.mainButton.scroll_gm = ScrollControl.Create( self.scroll_control )
	self.mainButton.scroll_gm:SetScrollable( true, false )
	self.mainButton.scroll_gm:SetSize( Vector2( self.window:GetSize().x - 15, 190 ) )
	self.mainButton.scroll_gm:SetDock( GwenPosition.Top )
	self.mainButton.scroll_gm:SetMargin( Vector2( 5, 10 ), Vector2( 5, 10 ) )

    self.mainButton.hunt_IMG = ImagePanel.Create( self.mainButton.scroll_gm )
	self.mainButton.hunt_IMG:SetImage( self.manhuntimage )
	self.mainButton.hunt_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.mainButton.hunt_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.mainButton.hunt = MenuItem.Create( self.mainButton.scroll_gm )
	self.mainButton.hunt:SetPosition( self.mainButton.hunt_IMG:GetPosition() )
	self.mainButton.hunt:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.mainButton.hunt:SetWidth( self.mainButton.hunt_IMG:GetSize().x )
	self.mainButton.hunt:SetText( "Охота" )
	self.mainButton.hunt:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.mainButton.hunt:SetTextSize( 19 )
	self.mainButton.hunt:SetToolTip( "Выживайте и убивайте игроков на небольшом острове." )
	self.mainButton.hunt:Subscribe( "Press", self, self.HuntToggle )

	self.mainButton.carbattles_IMG = ImagePanel.Create( self.mainButton.scroll_gm )
	self.mainButton.carbattles_IMG:SetImage( self.carbattlesimage )
	self.mainButton.carbattles_IMG:SetPosition( Vector2( self.mainButton.hunt:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 0 ) )
	self.mainButton.carbattles_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.mainButton.carbattles_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.mainButton.carbattles = MenuItem.Create( self.mainButton.scroll_gm )
	self.mainButton.carbattles:SetPosition( self.mainButton.carbattles_IMG:GetPosition() )
	self.mainButton.carbattles:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.mainButton.carbattles:SetWidth( self.mainButton.carbattles_IMG:GetSize().x )
	self.mainButton.carbattles:SetText( "Бои на тачках" )
	self.mainButton.carbattles:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.mainButton.carbattles:SetTextSize( 19 )
	self.mainButton.carbattles:SetToolTip( "Сражайтесь и выживайте на тачках." )
	self.mainButton.carbattles:Subscribe( "Press", self, self.CarBattlesToggle )

	self.mainButton.race_IMG = ImagePanel.Create( self.mainButton.scroll_gm )
	self.mainButton.race_IMG:SetImage( self.raceimage )
	self.mainButton.race_IMG:SetPosition( Vector2( self.mainButton.carbattles:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 0 ) )
	self.mainButton.race_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.mainButton.race_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.mainButton.race = MenuItem.Create( self.mainButton.scroll_gm )
	self.mainButton.race:SetPosition( self.mainButton.race_IMG:GetPosition() )
	self.mainButton.race:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.mainButton.race:SetWidth( self.mainButton.race_IMG:GetSize().x )
	self.mainButton.race:SetText( "Гонки" )
	self.mainButton.race:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.mainButton.race:SetTextSize( 19 )
	self.mainButton.race:SetToolTip( "Доберитесь первым до финиша среди прочих гонщиков." )
	self.mainButton.race:Subscribe( "Press", self, self.RaceToggle )

	self.mainButton.tron_IMG = ImagePanel.Create( self.mainButton.scroll_gm )
	self.mainButton.tron_IMG:SetImage( self.tronimage )
	self.mainButton.tron_IMG:SetPosition( Vector2( self.mainButton.race_IMG:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 0 ) )
	self.mainButton.tron_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.mainButton.tron_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.mainButton.tron = MenuItem.Create( self.mainButton.scroll_gm )
	self.mainButton.tron:SetPosition( self.mainButton.tron_IMG:GetPosition() )
	self.mainButton.tron:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.mainButton.tron:SetWidth( self.mainButton.tron_IMG:GetSize().x )
	self.mainButton.tron:SetText( "Трон" )
	self.mainButton.tron:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.mainButton.tron:SetTextSize( 19 )
	self.mainButton.tron:SetToolTip( "Заманивайте других игроков в свою полосу, чтобы одержать победу." )
	self.mainButton.tron:Subscribe( "Press", self, self.TronToggle )

	self.mainButton.khill_IMG = ImagePanel.Create( self.mainButton.scroll_gm )
	self.mainButton.khill_IMG:SetImage( self.kinghillimage )
	self.mainButton.khill_IMG:SetPosition( Vector2( self.mainButton.tron_IMG:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 0 ) )
	self.mainButton.khill_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.mainButton.khill_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.mainButton.khill = MenuItem.Create( self.mainButton.scroll_gm )
	self.mainButton.khill:SetPosition( self.mainButton.khill_IMG:GetPosition() )
	self.mainButton.khill:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.mainButton.khill:SetWidth( self.mainButton.khill_IMG:GetSize().x )
	self.mainButton.khill:SetText( "Царь горы" )
	self.mainButton.khill:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.mainButton.khill:SetTextSize( 19 )
	self.mainButton.khill:SetToolTip( "Доберитесь первым до вершины горы, чтобы одержать победу." )
	self.mainButton.khill:Subscribe( "Press", self, self.KHillToggle )

	self.mainButton.derby_IMG = ImagePanel.Create( self.mainButton.scroll_gm )
	self.mainButton.derby_IMG:SetImage( self.carbattlesimage )
	self.mainButton.derby_IMG:SetPosition( Vector2( self.mainButton.khill_IMG:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 0 ) )
	self.mainButton.derby_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.mainButton.derby_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.mainButton.derby = MenuItem.Create( self.mainButton.scroll_gm )
	self.mainButton.derby:SetPosition( self.mainButton.derby_IMG:GetPosition() )
	self.mainButton.derby:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.mainButton.derby:SetWidth( self.mainButton.derby_IMG:GetSize().x )
	self.mainButton.derby:SetText( "Дерби" )
	self.mainButton.derby:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.mainButton.derby:SetTextSize( 19 )
	self.mainButton.derby:SetToolTip( "Ушатывайте машины других игроков стараясь выжить сами." )
	self.mainButton.derby:Subscribe( "Press", self, self.DerbyToggle )

	self.mainButton.txtlabel_mg = Label.Create( self.scroll_control )
	self.mainButton.txtlabel_mg:SetText( "Прочие:" )
	self.mainButton.txtlabel_mg:SetDock( GwenPosition.Top )
	self.mainButton.txtlabel_mg:SetMargin( Vector2( 5, 0 ), Vector2( 0, 0 ) )
	self.mainButton.txtlabel_mg:SizeToContents()

	self.mainButton.scroll_mg = ScrollControl.Create( self.scroll_control )
	self.mainButton.scroll_mg:SetScrollable( true, false )
	self.mainButton.scroll_mg:SetSize( Vector2( self.window:GetSize().x - 15, 190 ) )
	self.mainButton.scroll_mg:SetDock( GwenPosition.Top )
	self.mainButton.scroll_mg:SetMargin( Vector2( 5, 10 ), Vector2( 5, 10 ) )

	self.mainButton.tetris_IMG = ImagePanel.Create( self.mainButton.scroll_mg )
	self.mainButton.tetris_IMG:SetImage( self.tetrisimage )
	self.mainButton.tetris_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2 )
	self.mainButton.tetris_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2 )

	self.mainButton.tetris = MenuItem.Create( self.mainButton.scroll_mg )
	self.mainButton.tetris:SetPosition( self.mainButton.tetris_IMG:GetPosition() )
	self.mainButton.tetris:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 / 1.15 )
	self.mainButton.tetris:SetWidth( self.mainButton.tetris_IMG:GetSize().x )
	self.mainButton.tetris:SetText( "Тетрис" )
	self.mainButton.tetris:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) / 1.15 ), Vector2.Zero )
	self.mainButton.tetris:SetTextSize( 19 )
	self.mainButton.tetris:SetToolTip( "Классический тетрис." )
	self.mainButton.tetris:Subscribe( "Press", self, self.TetrisToggle )

	self.mainButton.pong_IMG = ImagePanel.Create( self.mainButton.scroll_mg )
	self.mainButton.pong_IMG:SetImage( self.pongimage )
	self.mainButton.pong_IMG:SetPosition( Vector2( self.mainButton.tetris_IMG:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2 + 15, 0 ) )
	self.mainButton.pong_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2 )
	self.mainButton.pong_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2)

	self.mainButton.pong = MenuItem.Create( self.mainButton.scroll_mg )
	self.mainButton.pong:SetPosition( self.mainButton.pong_IMG:GetPosition() )
	self.mainButton.pong:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 / 1.15 )
	self.mainButton.pong:SetWidth( self.mainButton.pong_IMG:GetSize().x )
	self.mainButton.pong:SetText( "Понг" )
	self.mainButton.pong:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) / 1.15 ), Vector2.Zero )
	self.mainButton.pong:SetTextSize( 19 )
	self.mainButton.pong:SetToolTip( "Гопник ждет вас в понг." )
	self.mainButton.pong:Subscribe( "Press", self, self.PongToggle )

	self.mainButton.casino_IMG = ImagePanel.Create( self.mainButton.scroll_mg )
	self.mainButton.casino_IMG:SetImage( self.casinoimage )
	self.mainButton.casino_IMG:SetPosition( Vector2( self.mainButton.pong_IMG:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2 + 15, 0 ) )
	self.mainButton.casino_IMG:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2 )
	self.mainButton.casino_IMG:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) / 1.2)

	self.mainButton.casino = MenuItem.Create( self.mainButton.scroll_mg )
	self.mainButton.casino:SetPosition( self.mainButton.casino_IMG:GetPosition() )
	self.mainButton.casino:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 / 1.15 )
	self.mainButton.casino:SetWidth( self.mainButton.casino_IMG:GetSize().x )
	self.mainButton.casino:SetText( "Казино" )
	self.mainButton.casino:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) / 1.15 ), Vector2.Zero )
	self.mainButton.casino:SetTextSize( 19 )
	self.mainButton.casino:SetToolTip( "Азартные игры на деньги." )
	self.mainButton.casino:Subscribe( "Press", self, self.CasinoToggle )
end

function GameModesMenu:HuntToggle()
	Events:Fire( "GoHunt" )
	self:GameModesMenuClosed()
end

function GameModesMenu:CarBattlesToggle()
	Events:Fire( "GoCB" )
	self:GameModesMenuClosed()
end

function GameModesMenu:RaceToggle()
	Events:Fire( "EnableRaceMenu" )
	self:GameModesMenuClosed()
end

function GameModesMenu:TronToggle()
	Network:Send( "GoTron" )
	self:GameModesMenuClosed()
end

function GameModesMenu:KHillToggle()
	Network:Send( "GoKHill" )
	self:GameModesMenuClosed()
end

function GameModesMenu:DerbyToggle()
	Network:Send( "GoDerby" )
	self:GameModesMenuClosed()
end

function GameModesMenu:TetrisToggle()
	Events:Fire( "TetrisToggle" )
	self:GameModesMenuClosed()
end

function GameModesMenu:PongToggle()
	self.inpong = not self.inpong
	if self.inpong then
		Network:Send( "GoPong" )
	else
		Network:Send( "LeavePong" )
	end
	self:GameModesMenuClosed()
end

function GameModesMenu:CasinoToggle()
	Events:Fire( "OpenCasinoMenu" )
	self:GameModesMenuClosed()
end

function GameModesMenu:LocalPlayerInput( args )
	if args.input == Action.GuiPause then
		if self.window:GetVisible() == true then
			self:WindowClosed()
		end
	end
	if self.actions[args.input] then
		return false
	end
end

function GameModesMenu:WindowClosed()
    self.window:SetVisible( false )

    Mouse:SetVisible( false )

    if self.LocalPlayerInputEvent then
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
end

function GameModesMenu:GameModesMenuClosed()
	self:WindowClosed()

	ClientEffect.Create(AssetLocation.Game, {
		effect_id = 383,

		position = Camera:GetPosition(),
		angle = Angle()
	})
end

gamemodesmenu = GameModesMenu()