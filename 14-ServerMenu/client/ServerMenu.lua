class 'ServerMenu'

function ServerMenu:__init()
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

	self.active = false
	self.resizer_txt = "Черный ниггер"
	self.resizer_txt2 = "Отклюючиить"

	self.hidemetxt = "Скрытие маркера"
	self.disabletxt = " отключено"
	self.enabletxt = " включено"

	self.cooldown = 0.5
	self.cooltime = 0

	self.shopimage = Image.Create( AssetLocation.Resource, "BlackMarketICO" )
	self.tpimage = Image.Create( AssetLocation.Resource, "TeleportICO" )
	self.clansimage = Image.Create( AssetLocation.Resource, "ClansICO" )
	self.pmimage = Image.Create( AssetLocation.Resource, "MessagesICO" )
	self.settimage = Image.Create( AssetLocation.Resource, "SettingsICO" )
	self.dedmimage = Image.Create( AssetLocation.Resource, "ArkoICO" )
	self.mainmenuimage = Image.Create( AssetLocation.Resource, "GameModesICO" )
	self.abiltiesimage = Image.Create( AssetLocation.Resource, "AbilitiesICO" )

	self:LoadCategories()

	Events:Subscribe( "Lang", self, self.Lang )
    Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
	Events:Subscribe( "LocalPlayerMoneyChange", self, self.LocalPlayerMoneyChange )

	Network:Subscribe( "Settings", self, self.Open )
	Network:Subscribe( "Bonus", self, self.Bonus )
end

function ServerMenu:Lang()
	self.window:SetTitle( "▧ Server Menu" )
	self.news_button:SetText( "NEWS" )
	self.help_button:SetText( "HELP / RULES" )
	self.shop_button:SetText( "Black Market" )
	self.shop_button:SetToolTip( "Vehicles, weapons, appearance and others." )
	self.tp_button:SetText( "Teleportation" )
	self.tp_button:SetToolTip( "Teleport to the players." )
	self.clans_button:SetText( "Clans" )
	self.clans_button:SetToolTip( "Your clan and other clans of players." )
	self.pm_button:SetText( "Messages" )
	self.pm_button:SetToolTip( "Communicate personally with the players." )
	self.sett_button:SetText( "Settings" )
	self.sett_button:SetToolTip( "Server Settings." )
	self.tasks_button:SetToolTip( "Daily tasks for which you get rewards." )
	self.tasks_button:SetText( "Daily Tasks" )
	self.minigames_button:SetText( "Minigames" )
	self.minigames_button:SetToolTip( "Various minigames." )
	self.abilities_button:SetText( "Abilities" )
	self.abilities_button:SetToolTip( "Upgrading your abilities and skills." )
	self.passive:SetText( "Passive mode:" )
	self.passive:SizeToContents()
	self.jesusmode:SetText( "Jesus mode:" )
	self.jesusmode:SizeToContents()
	self.hideme:SetText( "Marker Hide:" )
	self.bonus:SetText( "Bonus:" )
	self.bonus:SizeToContents()
	self.bonus_btn:SetText( "NEEDED 9 LEVEL" )

	self.hidemetxt = "Marker Hide"
	self.disabletxt = " disabled"
	self.enabletxt = " enabled"
end

function ServerMenu:LoadCategories()
	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.55, 0.5 ) )
	self.window:SetMinimumSize( Vector2( 500, 442 ) )
	self.window:SetPositionRel( Vector2( 0.7, 0.5 ) - self.window:GetSizeRel()/2 )
	self.window:SetVisible( self.active )
	self.window:SetTitle( "▧ Меню сервера" )
	self.window:Subscribe( "WindowClosed", self, self.WindowClosed )

	self.top_label = Label.Create( self.window )
	self.top_label:SetVisible( true )
	self.top_label:SetDock( GwenPosition.Top )
	self.top_label:SetHeight( 30 )

	self.help_button = Button.Create( self.top_label )
	self.help_button:SetVisible( true )
	self.help_button:SetText( "ПОМОЩЬ / ПРАВИЛА" )
	self.help_button:SetDock( GwenPosition.Fill )
	self.help_button:SetTextSize( 14 )
	self.help_button:SetMargin( Vector2( 5, 0 ), Vector2( 0, 0 ) )
	self.help_button:Subscribe( "Press", self, self.CastHelpMenu )

	self.news_button = Button.Create( self.top_label )
	self.news_button:SetVisible( true )
	self.news_button:SetText( "НОВОСТИ" )
	self.news_button:SetDock( GwenPosition.Left )
	self.news_button:SetTextSize( 14 )
	self.news_button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 0 ) )
	self.news_button:Subscribe( "Press", self, self.CastNewsMenu )

	self.scroll_control = ScrollControl.Create( self.window )
	self.scroll_control:SetScrollable( true, false )
	self.scroll_control:SetSize( Vector2( self.window:GetSize().x - 15, 215 ) )
	self.scroll_control:SetDock( GwenPosition.Top )

	self.shop_image = ImagePanel.Create( self.scroll_control )
	self.shop_image:SetImage( self.shopimage )
	self.shop_image:SetPosition( Vector2( 5, 20 ) )
	self.shop_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.shop_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.shop_button = MenuItem.Create( self.scroll_control )
	self.shop_button:SetPosition( self.shop_image:GetPosition() )
	self.shop_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.shop_button:SetWidth( self.shop_image:GetSize().x )
	self.shop_button:SetText( "Черный рынок" )
	self.shop_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.shop_button:SetTextSize( 19 )
	self.shop_button:SetToolTip( "Транспорт, оружие, внешность и прочие." )
	self.shop_button:Subscribe( "Press", self, self.CastShop )

	self.tp_image = ImagePanel.Create( self.scroll_control )
	self.tp_image:SetImage( self.tpimage )
	self.tp_image:SetPosition( Vector2( self.shop_image:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.tp_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.tp_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.tp_button = MenuItem.Create( self.scroll_control )
	self.tp_button:SetPosition( self.tp_image:GetPosition() )
	self.tp_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.tp_button:SetWidth( self.tp_image:GetSize().x )
	self.tp_button:SetText( "Телепортация" )
	self.tp_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.tp_button:SetTextSize( 19 )
	self.tp_button:SetToolTip( "Телепортация к игрокам." )
	self.tp_button:Subscribe( "Press", self, self.CastWarpGUI )

	self.clans_image = ImagePanel.Create( self.scroll_control )
	self.clans_image:SetImage( self.clansimage )
	self.clans_image:SetPosition( Vector2( self.tp_image:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.clans_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.clans_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.clans_button = MenuItem.Create( self.scroll_control )
	self.clans_button:SetPosition( self.clans_image:GetPosition() )
	self.clans_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.clans_button:SetWidth( self.clans_image:GetSize().x )
	self.clans_button:SetText( "Кланы" )
	self.clans_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.clans_button:SetTextSize( 19 )
	self.clans_button:SetToolTip( "Управление кланом и другие кланы игроков." )
	self.clans_button:Subscribe( "Press", self, self.CastClansMenu )

	self.pm_image = ImagePanel.Create( self.scroll_control )
	self.pm_image:SetImage( self.pmimage )
	self.pm_image:SetPosition( Vector2( self.clans_image:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.pm_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.pm_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.pm_button = MenuItem.Create( self.scroll_control )
	self.pm_button:SetPosition( self.pm_image:GetPosition() )
	self.pm_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.pm_button:SetWidth( self.pm_image:GetSize().x )
	self.pm_button:SetText( "Сообщения" )
	self.pm_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.pm_button:SetTextSize( 19 )
	self.pm_button:SetToolTip( "Общайтесь лично с игроками." )
	self.pm_button:Subscribe( "Press", self, self.CastGuiPm )

	self.tasks_image = ImagePanel.Create( self.scroll_control )
	self.tasks_image:SetImage( self.dedmimage )
	self.tasks_image:SetPosition( Vector2( self.pm_button:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.tasks_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.tasks_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.tasks_button = MenuItem.Create( self.scroll_control )
	self.tasks_button:SetPosition( self.tasks_image:GetPosition() )
	self.tasks_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.tasks_button:SetWidth( self.tasks_image:GetSize().x )
	self.tasks_button:SetText( "Задания" )
	self.tasks_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.tasks_button:SetTextSize( 19 )
	self.tasks_button:SetToolTip( "Ежедневные задания за которые вы получаете награды." )
	self.tasks_button:Subscribe( "Press", self, self.CastDedMorozMenu )

	self.minigames_image = ImagePanel.Create( self.scroll_control )
	self.minigames_image:SetImage( self.mainmenuimage )
	self.minigames_image:SetPosition( Vector2( self.tasks_button:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.minigames_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.minigames_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.minigames_button = MenuItem.Create( self.scroll_control )
	self.minigames_button:SetPosition( self.minigames_image:GetPosition() )
	self.minigames_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.minigames_button:SetWidth( self.minigames_image:GetSize().x )
	self.minigames_button:SetText( "Развлечения" )
	self.minigames_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.minigames_button:SetTextSize( 19 )
	self.minigames_button:SetToolTip( "Различные развлечения." )
	self.minigames_button:Subscribe( "Press", self, self.CastMainMenu )

	self.abilities_image = ImagePanel.Create( self.scroll_control )
	self.abilities_image:SetImage( self.abiltiesimage )
	self.abilities_image:SetPosition( Vector2( self.minigames_button:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.abilities_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.abilities_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.abilities_button = MenuItem.Create( self.scroll_control )
	self.abilities_button:SetPosition( self.abilities_image:GetPosition() )
	self.abilities_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.abilities_button:SetWidth( self.abilities_image:GetSize().x )
	self.abilities_button:SetText( "Способности" )
	self.abilities_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.abilities_button:SetTextSize( 19 )
	self.abilities_button:SetToolTip( "Прокачка способностей и навыков." )
	self.abilities_button:Subscribe( "Press", self, self.CastAbilitiesMenu )

	self.sett_image = ImagePanel.Create( self.scroll_control )
	self.sett_image:SetImage( self.settimage )
	self.sett_image:SetPosition( Vector2( self.abilities_image:GetPosition().x + Render:GetTextWidth( self.resizer_txt, 19 ) + 15, 20 ) )
	self.sett_image:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) )
	self.sett_image:SetWidth( Render:GetTextWidth( self.resizer_txt, 19 ) )

	self.sett_button = MenuItem.Create( self.scroll_control )
	self.sett_button:SetPosition( self.sett_image:GetPosition() )
	self.sett_button:SetHeight( Render:GetTextWidth( self.resizer_txt, 19 ) * 1.25 )
	self.sett_button:SetWidth( self.sett_image:GetSize().x )
	self.sett_button:SetText( "Настройки" )
	self.sett_button:SetTextPadding( Vector2( 0, Render:GetTextWidth( self.resizer_txt, 19 ) ), Vector2.Zero )
	self.sett_button:SetTextSize( 19 )
	self.sett_button:SetToolTip( "Настройки сервера." )
	self.sett_button:Subscribe( "Press", self, self.CastSettingsMenu )

	self.leftlabel = Label.Create( self.window )
	self.leftlabel:SetDock( GwenPosition.Left )
	self.leftlabel:SetMargin( Vector2( 0, 15 ), Vector2( 5, 5 ) )
	self.leftlabel:SetSize( Vector2( Render:GetTextHeight( self.resizer_txt2, 14 ) + 400, 0 ) )

	self.passive = Label.Create( self.leftlabel )
	self.passive:SetTextColor( Color.MediumSpringGreen )
	self.passive:SetText( "Мирный режим:" )
	self.passive:SetPosition( Vector2( 5, 0 ) )
	self.passive:SizeToContents()

	self.passiveon_btn = Button.Create( self.leftlabel )
	self.passiveon_btn:SetVisible( true )
	self.passiveon_btn:SetText( "Включить" )
	self.passiveon_btn:SetSize( Vector2( Render:GetTextWidth( self.resizer_txt2, 14 ), Render:GetTextHeight( self.resizer_txt2, 14 ) + 15 ) )
	self.passiveon_btn:SetTextSize( 14 )
	self.passiveon_btn:SetPosition( Vector2( 5, 20 ) )
	self.passiveon_btn:Subscribe( "Press", self, self.CastPassive )

	self.jesusmode = Label.Create( self.leftlabel )
	self.jesusmode:SetTextColor( Color.LightBlue )
	self.jesusmode:SetText( "Режим Иисуса:" )
	self.jesusmode:SetPosition( Vector2( self.passiveon_btn:GetSize().x + self.passiveon_btn:GetPosition().x + 10, 0 ) )
	self.jesusmode:SizeToContents()

	self.jesusmode_btn = Button.Create( self.leftlabel )
	self.jesusmode_btn:SetText( "Включить" )
	self.jesusmode_btn:SetSize( Vector2( Render:GetTextWidth( self.resizer_txt2, 14 ), Render:GetTextHeight( self.resizer_txt2, 14 ) + 15 ) )
	self.jesusmode_btn:SetTextSize( 14 )
	self.jesusmode_btn:SetPosition( Vector2( self.passiveon_btn:GetSize().x + self.passiveon_btn:GetPosition().x + 10, 20 ) )
	self.jesusmode_btn:Subscribe( "Press", self, self.CastJesusMode )

	self.hideme = Label.Create( self.leftlabel )
	self.hideme:SetTextColor( Color.LightBlue )
	self.hideme:SetText( "Скрытие маркера:" )
	self.hideme:SetPosition( Vector2( self.jesusmode_btn:GetSize().x + self.jesusmode_btn:GetPosition().x + 10, 0 ) )
	self.hideme:SizeToContents()

	self.hideme_btn = Button.Create( self.leftlabel )
	self.hideme_btn:SetText( "Включить" )
	self.hideme_btn:SetSize( Vector2( Render:GetTextWidth( self.resizer_txt2, 14 ) * 1.15, Render:GetTextHeight( self.resizer_txt2, 14 ) + 15 ) )
	self.hideme_btn:SetTextSize( 14 )
	self.hideme_btn:SetPosition( Vector2( self.jesusmode_btn:GetSize().x + self.jesusmode_btn:GetPosition().x + 10, 20 ) )
	self.hideme_btn:Subscribe( "Press", self, self.CastHideMe )

	self.rightlabel = Label.Create( self.window )
	self.rightlabel:SetDock( GwenPosition.Right )
	self.rightlabel:SetMargin( Vector2( 0, 15 ), Vector2( 5, 5 ) )
	self.rightlabel:SetSize( Vector2( 230, 0 ) )

	self.bonus = Label.Create( self.rightlabel )
	self.bonus:SetText( "Награды:" )
	self.bonus:SetDock( GwenPosition.Top )
	self.bonus:SetMargin( Vector2( 0, 0 ), Vector2( 0, 6 ) )
	self.bonus:SizeToContents()

	self.bonus_btn = Button.Create( self.rightlabel )
	self.bonus_btn:SetEnabled( false )
	self.bonus_btn:SetText( "Достигните 9-го уровня" )
	self.bonus_btn:SetSize( Vector2( 215, Render:GetTextHeight( self.resizer_txt2, 14 ) + 15 ) )
	self.bonus_btn:SetTextHoveredColor( Color.Yellow )
	self.bonus_btn:SetTextPressedColor( Color.Yellow )
	self.bonus_btn:SetTextSize( 15 )
	self.bonus_btn:SetDock( GwenPosition.Top )
	self.bonus_btn:Subscribe( "Press", self, self.Cash )

	self.tetris_btn = Button.Create( self.rightlabel )
	self.tetris_btn:SetText( "□□□" )
	self.tetris_btn:SetSize( Vector2( 0, Render:GetTextHeight( "□□□", 15 ) + 5 ) )
	self.tetris_btn:SetTextSize( 15 )
	self.tetris_btn:SetDock( GwenPosition.Bottom )
	self.tetris_btn:SetMargin( Vector2( 190, 5 ), Vector2( 0, 0 ) )
	self.tetris_btn:Subscribe( "Press", self, function() self:WindowClosed() Events:Fire( "TetrisToggle" ) end )

	self.gametime = Label.Create( self.leftlabel )
	self.gametime:SetTextColor( Color.DarkGray )
	self.gametime:SetText( "Игровое время: 00:00" )
	self.gametime:SizeToContents()
	self.gametime:SetMargin( Vector2( 10, 5 ), Vector2( 0, 15 ) )
	self.gametime:SetDock( GwenPosition.Bottom )

	self.level = Label.Create( self.leftlabel )
	self.level:SetTextColor( Color( 251, 184, 41 ) )
	self.level:SetTextSize( 20 )
	self.level:SetText( "Баланс: $" .. formatNumber( LocalPlayer:GetMoney() ) )
	self.level:SizeToContents()
	self.level:SetMargin( Vector2( 10, 5 ), Vector2( 0, 0 ) )
	self.level:SetDock( GwenPosition.Bottom )
end

function ServerMenu:Open()
	self:SetWindowVisible( not self.active )
	if self.active then
		if not self.RenderEvent then
			self.RenderEvent = Events:Subscribe( "Render", self, self.Render )
		end
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 382,

			position = Camera:GetPosition(),
			angle = Angle()
		})
	else
		if self.RenderEvent then
			Events:Unsubscribe( self.RenderEvent )
			self.RenderEvent = nil
		end
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 383,

			position = Camera:GetPosition(),
			angle = Angle()
		})
	end
end

function ServerMenu:LocalPlayerInput( args )
	if self.window:GetVisible() == true then
		if args.input == Action.GuiPause then
			self:SetWindowVisible( false )
			if self.RenderEvent then
				Events:Unsubscribe( self.RenderEvent )
				self.RenderEvent = nil
			end
		end
		if args.input ~= Action.EquipBlackMarketBeacon then
			if self.actions[args.input] then
				return false
			end
		end
	end

	if Game:GetSetting(GameSetting.GamepadInUse) == 1 then
		if args.input == Action.EquipBlackMarketBeacon then
			if Game:GetState() ~= GUIState.Game then return end
			local time = Client:GetElapsedSeconds()
			if time < self.cooltime then
				return
			else
				self:Open()
				Events:Fire( "CloseNewsMenu" )
				Events:Fire( "CloseHelpMenu" )
				Events:Fire( "CloseShop" )
				Events:Fire( "CloseWarpGUI" )
				Events:Fire( "CloseClansMenu" )
				Events:Fire( "CloseGuiPm" )
				Events:Fire( "CloseSettingsMenu" )
				Events:Fire( "CloseDedMorozMenu" )
				Events:Fire( "CloseGameModesMenu" )
				Events:Fire( "CloseAbitiliesMenu" )
			end
			self.cooltime = time + self.cooldown
			return false
		end
	end
end

function ServerMenu:KeyUp( args )
	if Game:GetState() ~= GUIState.Game then return end

	if args.key == string.byte('B') then
		self:Open()
		Events:Fire( "CloseNewsMenu" )
		Events:Fire( "CloseHelpMenu" )
		Events:Fire( "CloseShop" )
		Events:Fire( "CloseWarpGUI" )
		Events:Fire( "CloseClansMenu" )
		Events:Fire( "CloseGuiPm" )
		Events:Fire( "CloseSettingsMenu" )
		Events:Fire( "CloseDedMorozMenu" )
		Events:Fire( "CloseGameModesMenu" )
		Events:Fire( "CloseAbitiliesMenu" )
		Events:Fire( "CasinoMenuClosed" )
		Events:Fire( "CloseSendMoney" )
    end
end

function ServerMenu:WindowClosed( args )
	self:SetWindowVisible( false )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
	ClientEffect.Create(AssetLocation.Game, {
		effect_id = 383,

		position = Camera:GetPosition(),
		angle = Angle()
	})
end

function ServerMenu:Render()
	local is_visible = self.active and (Game:GetState() == GUIState.Game)

    local gettime = Game:GetTime()
    local hh, timedec = math.modf(gettime)
    local mm, _ = math.modf(59*timedec)

	if LocalPlayer:GetValue( "Lang" ) == "РУС" then
		self.gametime:SetText( "Игровое время: " .. string.format("%d:%02d", hh, mm) )
	else
		self.gametime:SetText( "Game Time: " .. string.format("%d:%02d", hh, mm) )
	end

	if self.window:GetVisible() ~= is_visible then
		self.window:SetVisible( is_visible )
	end
end

function ServerMenu:SetWindowVisible( visible )
    if self.active ~= visible then
		self.active = visible
		self.window:SetVisible( visible )
		Mouse:SetVisible( visible )

		self.scroll_control:SetSize( Vector2( self.window:GetSize().x - 15, self.shop_button:GetHeight() + 45 ) )

		if LocalPlayer:GetValue( "SystemFonts" ) then
			self.shop_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.tp_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.clans_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.pm_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.sett_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.tasks_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.minigames_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.abilities_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.level:SetFont( AssetLocation.SystemFont, "Impact" )
			self.help_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.news_button:SetFont( AssetLocation.SystemFont, "Impact" )
			self.passiveon_btn:SetFont( AssetLocation.SystemFont, "Impact" )
			self.jesusmode_btn:SetFont( AssetLocation.SystemFont, "Impact" )
			self.hideme_btn:SetFont( AssetLocation.SystemFont, "Impact" )
			self.bonus_btn:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		if LocalPlayer:GetValue( "Lang" ) then
			if LocalPlayer:GetValue( "Lang" ) == "РУС" then
				self.level:SetText( "Баланс: $" .. formatNumber( LocalPlayer:GetMoney() ) )
			else
				self.level:SetText( "Money: $" .. formatNumber( LocalPlayer:GetMoney() ) )
			end

			if LocalPlayer:GetValue( "Passive" ) then
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.passiveon_btn:SetText( "Отключить" )
				else
					self.passiveon_btn:SetText( "Disable" )
				end
			else
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.passiveon_btn:SetText( "Включить" )
				else
					self.passiveon_btn:SetText( "Enable" )
				end
			end
			if LocalPlayer:GetValue( "WaterWalk" ) then
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.jesusmode_btn:SetText( "Отключить" )
				else
					self.jesusmode_btn:SetText( "Disable" )
				end
			else
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.jesusmode_btn:SetText( "Включить" )
				else
					self.jesusmode_btn:SetText( "Enable" )
				end
			end
			if LocalPlayer:GetValue( "HideMe" ) then
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.hideme_btn:SetText( "Отключить" )
				else
					self.hideme_btn:SetText( "Disable" )
				end
			else
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.hideme_btn:SetText( "Включить" )
				else
					self.hideme_btn:SetText( "Enable" )
				end
			end
			if LocalPlayer:GetValue( "MoneyBonus" ) then
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.bonus_btn:SetText( "$$ Денежный бонус $$" )
				else
					self.bonus_btn:SetText( "$$ Money bonus $$" )
				end
			else
				if LocalPlayer:GetValue( "Lang" ) == "РУС" then
					self.bonus_btn:SetText( "Недоступно :(" )
				else
					self.bonus_btn:SetText( "Not available" )
				end
			end
		end
		if LocalPlayer:GetWorld() == DefaultWorld then
			self.shop_button:SetEnabled( true )
			self.tp_button:SetEnabled( true )
			self.passiveon_btn:SetEnabled( true )
			if LocalPlayer:GetValue( "JesusModeEnabled" ) then
				self.jesusmode_btn:SetEnabled( true )
			else
				self.jesusmode_btn:SetEnabled( false )
			end
			self.hideme_btn:SetEnabled( true )
		else
			self.shop_button:SetEnabled( false )
			self.tp_button:SetEnabled( false )
			self.passiveon_btn:SetEnabled( false )
			self.jesusmode_btn:SetEnabled( false )
			self.hideme_btn:SetEnabled( false )
		end
	end
end

function ServerMenu:CastNewsMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenNewsMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
	if self.LocalPlayerInputEvent then
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
end

function ServerMenu:CastHelpMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenHelpMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastShop()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenShop" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastWarpGUI()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenWarpGUI" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastClansMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenClansMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastGuiPm()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenGuiPm" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastSettingsMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenSettingsMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastDedMorozMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenDedMorozMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastMainMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenGameModesMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
	if self.LocalPlayerInputEvent then
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
end

function ServerMenu:CastAbilitiesMenu()
	self:SetWindowVisible( not self.active )
	Events:Fire( "OpenAbitiliesMenu" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
	if self.LocalPlayerInputEvent then
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
end

function ServerMenu:CastPassive()
	self:SetWindowVisible( not self.active )
	Events:Fire( "PassiveOn" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastJesusMode()
	self:SetWindowVisible( not self.active )
	Events:Fire( "JesusToggle" )
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end

function ServerMenu:CastHideMe()
	self:SetWindowVisible( not self.active )
	Network:Send( "ToggleHideMe" )
	if LocalPlayer:GetValue( "HideMe" ) then
		Events:Fire( "CastCenterText", { text = self.hidemetxt .. self.disabletxt, time = 2, color = Color.LightBlue } )
	else
		Events:Fire( "CastCenterText", { text = self.hidemetxt .. self.enabletxt, time = 2, color = Color.LightBlue } )
	end
	if self.RenderEvent then
		Events:Unsubscribe( self.RenderEvent )
		self.RenderEvent = nil
	end
end


function ServerMenu:Cash()
	Network:Send( "Cash" )
	self.bonus_btn:SetEnabled( false )
	local sound = ClientSound.Create(AssetLocation.Game, {
			bank_id = 20,
			sound_id = 20,
			position = LocalPlayer:GetPosition(),
			angle = Angle()
	})

	sound:SetParameter(0,1)
end

function ServerMenu:Bonus()
	if LocalPlayer:GetValue( "MoneyBonus" ) then
		self.bonus_btn:SetEnabled( true )
		if LocalPlayer:GetValue( "Lang" ) == "ENG" then
			Chat:Print( "[Bonus] ", Color.White, "Money bonus is available! Open the server menu to get it!", Color.GreenYellow )
		else
			Chat:Print( "[Бонус] ", Color.White, "Доступен денежный бонус! Откройте меню сервера, чтобы получить его.", Color.GreenYellow )
		end
	end
end

function ServerMenu:UpdateMoneyString( money )
    if money == nil then
        money = LocalPlayer:GetMoney()
    end

    if LocalPlayer:GetValue( "Lang" ) then
		if LocalPlayer:GetValue( "Lang" ) == "РУС" then
			self.level:SetText( "Баланс: $" .. formatNumber( money ) )
		else
			self.level:SetText( "Money: $" .. formatNumber( money ) )
		end
    end
end

function ServerMenu:LocalPlayerMoneyChange( args )
    self:UpdateMoneyString( args.new_money )
end

function math.round( number, decimals, method )
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
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

servermenu = ServerMenu()