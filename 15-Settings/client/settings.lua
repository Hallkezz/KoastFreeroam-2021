class 'Settings'

function Settings:__init()
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
		[16] = true,
		[114] = true,
		[115] = true,
		[117] = true,
		[116] = true
	}

	self.BackgroundImage = Image.Create( AssetLocation.Resource, "BackgroundImage" )
	self.BackgroundImageTw = Image.Create( AssetLocation.Resource, "BackgroundImageTw" )
	self.BackgroundImageTh = Image.Create( AssetLocation.Resource, "BackgroundImageTh" )
	self.BackgroundImageFo = Image.Create( AssetLocation.Resource, "BackgroundImageFo" )
	self.BackgroundImageFi = Image.Create( AssetLocation.Resource, "BackgroundImageFi" )
	self.BackgroundImageSi = Image.Create( AssetLocation.Resource, "BackgroundImageSi" )
	self.BackgroundImageSe = Image.Create( AssetLocation.Resource, "BackgroundImageSi" )

	self.active = false
	self.actvPM = true
	if LocalPlayer:GetValue( "LongerGrapple" ) then
		self.actvH = true
	else
		self.actvH = false
	end
	self.actvHu = true
	self.actvMb = true
	self.actvCH = LocalPlayer:GetValue( "CustomCrosshair" )
	self.actvSn = false
	self.gethide = false

	self.aim = true

	self.unit = 0

	if LocalPlayer:GetValue( "Tag" ) == "Creator" or LocalPlayer:GetValue( "Tag" ) == "GlAdmin" or LocalPlayer:GetValue( "Tag" ) == "Admin"
		or LocalPlayer:GetValue( "Tag" ) == "AdminD" or LocalPlayer:GetValue( "Tag" ) == "ModerD" or LocalPlayer:GetValue( "Tag" ) == "VIP" then
		self.roll = true
	else
		self.roll = false
	end
	self.spin = false
	self.flip = false

	self:LoadCategories()

	Events:Subscribe( "Render", self, self.Render )
	Network:Subscribe( "ResetDone", self, self.ResetDone )

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "LoadUI", self, self.LoadUI )
	Events:Subscribe( "GameLoad", self, self.GameLoad )
	Events:Subscribe( "GameRender", self, self.GameRender )
	Events:Subscribe( "OpenSettingsMenu", self, self.OpenSettingsMenu )
	Events:Subscribe( "CloseSettingsMenu", self, self.CloseSettingsMenu )
	Events:Subscribe( "KeyUp", self, self.KeyHide )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )

	self:GameLoad()
end

function Settings:Lang()
	self.window:SetTitle( "▧ Settings" )
	self.hidetexttip:SetText( "Press F11 to hide/show UI" )
	self.hidetext:SetText( "Used full UI hiding" )
	self.hidetexttip:SizeToContents()
	self.hidetext:SizeToContents()
	self.buttonBoost:SetText( "Boost setting (for vehicle)" )
	self.buttonSpeedo:SetText( "Speedometer setting" )
	self.buttonSDS:SetText( "Skydiving settings" )
	self.buttonTags:SetText( "Tags settings" )
	self.buttonChatSett:SetText( "Chat settings" )
	self.texter:SetText( "Saves:" )
	self.buttonSPOff:SetText( "Reset Saved Position" )
end

function Settings:LoadUI()
	self:GameLoad()
end

function Settings:LoadCategories()
	self.window = Window.Create()
	self.window:SetSizeRel( Vector2( 0.5, 0.5 ) )
	self.window:SetMinimumSize( Vector2( 680, 442 ) )
	self.window:SetPositionRel( Vector2( 0.73, 0.5 ) - self.window:GetSizeRel()/2 )
	self.window:SetVisible( self.active )
	self.window:SetTitle( "▧ Настройки" )
	self.window:Subscribe( "WindowClosed", self, self.WindowClosed )

	self.tab = TabControl.Create( self.window )
	self.tab:SetDock( GwenPosition.Fill )

	local widgets = BaseWindow.Create( self.window )
	self.tab:AddPage( "Основное", widgets )

	local scroll_control = ScrollControl.Create( widgets )
	scroll_control:SetScrollable( false, true )
	scroll_control:SetDock( GwenPosition.Fill )
	scroll_control:SetMargin( Vector2( 5, 5 ), Vector2( 2, 5 ) )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать часы" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "ClockVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 1 , boolean = not LocalPlayer:GetValue( "ClockVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "12-часовой формат" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 20 ) )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "ClockPendosFormat" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 2 , boolean = not LocalPlayer:GetValue( "ClockPendosFormat" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать 'Мирный' вверху экрана" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "PassiveModeVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 4 , boolean = not LocalPlayer:GetValue( "PassiveModeVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать хорошечные рекорды" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "BestRecordVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 3 , boolean = not LocalPlayer:GetValue( "BestRecordVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать чат убийств" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 20 ) )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "KillFeedVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 6 , boolean = not LocalPlayer:GetValue( "KillFeedVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать подсказку под чатом" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "ChatTipsVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 7 , boolean = not LocalPlayer:GetValue( "ChatTipsVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать фон чата" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 20 ) )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "ChatBackgroundVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 8 , boolean = not LocalPlayer:GetValue( "ChatBackgroundVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать маркеры игроков" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "PlayersMarkersVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 9 , boolean = not LocalPlayer:GetValue( "PlayersMarkersVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать маркеры заданий" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "JobsMarkersVisible" ) )
	button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 20 ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 10 , boolean = not LocalPlayer:GetValue( "JobsMarkersVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать прицел" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( self.aim )
	button:GetCheckBox():Subscribe( "CheckChanged", self, self.ToggleAim )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Серверный прицел" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "CustomCrosshair" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() self.actvCH = not LocalPlayer:GetValue( "CustomCrosshair" ) self:GameLoad() Network:Send( "UpdateParameters", { parameter = 11 , boolean = not LocalPlayer:GetValue( "CustomCrosshair" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Индикатор дальнего крюка" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 20 ) )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "LongerGrappleVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 12 , boolean = not LocalPlayer:GetValue( "LongerGrappleVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Jet HUD (для авиации)" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Events:Fire( "JHudActive" ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать задания на карте" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( LocalPlayer:GetValue( "JobsVisible" ) )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 13 , boolean = not LocalPlayer:GetValue( "JobsVisible" ) } ) end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Отображать снег на экране" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:SetMargin( Vector2( 0, 0 ), Vector2( 0, 20 ) )
	button:GetCheckBox():SetChecked( self.actvSn )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() self.actvSn = button:GetCheckBox():GetChecked() self:GameLoad() end )

	self.JesusVisButton = LabeledCheckBox.Create( scroll_control )
	self.JesusVisButton:GetLabel():SetText( "Отображать 'Иисус' вверху экрана" )
	self.JesusVisButton:SetSize( Vector2( 300, 20 ) )
	self.JesusVisButton:GetLabel():SetTextSize( 15 )
	self.JesusVisButton:SetDock( GwenPosition.Top )
	self.JesusVisButton:GetCheckBox():SetChecked( LocalPlayer:GetValue( "JesusModeVisible" ) )
	self.JesusVisButton:GetCheckBox():Subscribe( "CheckChanged",
		function() Network:Send( "UpdateParameters", { parameter = 5 , boolean = not LocalPlayer:GetValue( "JesusModeVisible" ) } ) end )

	self.bkpanelsLabel = Label.Create( widgets )
	self.bkpanelsLabel:SetVisible( true )
	self.bkpanelsLabel:SetDock( GwenPosition.Right )
	self.bkpanelsLabel:SetMargin( Vector2( 5, 0 ), Vector2( 5, 0 ) )
	self.bkpanelsLabel:SetSize( Vector2( 320, 0 ) )

	self.hidetexttip = Label.Create( self.bkpanelsLabel )
	self.hidetexttip:SetText( "Нажмите F11, чтобы скрыть/показать интерфейс" )
	self.hidetexttip:SetDock( GwenPosition.Bottom )
	self.hidetexttip:SetMargin( Vector2( 0, 2 ), Vector2( 0, 4 ) )
	self.hidetexttip:SizeToContents()

	self.hidetext = Label.Create( self.bkpanelsLabel )
	self.hidetext:SetVisible( false )
	self.hidetext:SetText( "Используется полное скрытие интерфейса" )
	self.hidetext:SetTextColor( Color.Yellow )
	self.hidetext:SetDock( GwenPosition.Bottom )
	self.hidetext:SetMargin( Vector2( 0, 2 ), Vector2( 0, 2 ) )
	self.hidetext:SizeToContents()

	self.buttonBoost = Button.Create( self.bkpanelsLabel )
	self.buttonBoost:SetText( "Настройка ускорения (для ТС)" )
	self.buttonBoost:SetSize( Vector2( 0, 30 ) )
	self.buttonBoost:SetTextSize( 14 )
	self.buttonBoost:SetDock( GwenPosition.Top )
	self.buttonBoost:SetMargin( Vector2( 0, 3 ), Vector2( 0, 3 ) )
	self.buttonBoost:Subscribe( "Press", self, function() Events:Fire( "BoostSettings" ) end )

	self.buttonSpeedo = Button.Create( self.bkpanelsLabel )
	self.buttonSpeedo:SetText( "Настройка спидометра" )
	self.buttonSpeedo:SetSize( Vector2( 0, 30 ) )
	self.buttonSpeedo:SetTextSize( 14 )
	self.buttonSpeedo:SetDock( GwenPosition.Top )
	self.buttonSpeedo:SetMargin( Vector2( 0, 3 ), Vector2( 0, 3 ) )
	self.buttonSpeedo:Subscribe( "Press", self, function() Events:Fire( "OpenSpeedometerMenu" ) end )

	self.buttonSDS = Button.Create( self.bkpanelsLabel )
	self.buttonSDS:SetText( "Настройка скайдайвинга" )
	self.buttonSDS:SetSize( Vector2( 0, 30 ) )
	self.buttonSDS:SetTextSize( 14 )
	self.buttonSDS:SetDock( GwenPosition.Top )
	self.buttonSDS:SetMargin( Vector2( 0, 3 ), Vector2( 0, 3 ) )
	self.buttonSDS:Subscribe( "Press", self, function() Events:Fire( "OpenSkydivingStatsMenu" ) end )

	self.buttonTags = Button.Create( self.bkpanelsLabel )
	self.buttonTags:SetText( "Настройка тегов" )
	self.buttonTags:SetSize( Vector2( 0, 30 ) )
	self.buttonTags:SetTextSize( 14 )
	self.buttonTags:SetDock( GwenPosition.Top )
	self.buttonTags:SetMargin( Vector2( 0, 3 ), Vector2( 0, 3 ) )
	self.buttonTags:Subscribe( "Press", self, function() Events:Fire( "OpenNametagsMenu" ) end )

	self.buttonChatSett = Button.Create( self.bkpanelsLabel )
	self.buttonChatSett:SetText( "Настройка чата" )
	self.buttonChatSett:SetSize( Vector2( 0, 30 ) )
	self.buttonChatSett:SetTextSize( 14 )
	self.buttonChatSett:SetDock( GwenPosition.Top )
	self.buttonChatSett:SetMargin( Vector2( 0, 3 ), Vector2( 0, 3 ) )
	self.buttonChatSett:Subscribe( "Press", self, function() Events:Fire( "OpenChatMenu" ) self:WindowClosed() end )

	self.texter = Label.Create( self.bkpanelsLabel )
	self.texter:SetText( "Сохранения:" )
	self.texter:SetDock( GwenPosition.Top )
	self.texter:SetMargin( Vector2( 0, 10 ), Vector2( 0, 4 ) )
	self.texter:SizeToContents()

	self.buttonSPOff = Button.Create( self.bkpanelsLabel )
	self.buttonSPOff:SetText( "Сбросить сохраненную позицию" )
	self.buttonSPOff:SetSize( Vector2( 0, 30 ) )
	self.buttonSPOff:SetTextSize( 14 )
	self.buttonSPOff:SetDock( GwenPosition.Top )
	self.buttonSPOff:SetMargin( Vector2( 0, 3 ), Vector2( 0, 3 ) )
	self.buttonSPOff:Subscribe( "Press", self, function() Network:Send( "SPOff" ) end )

	local powers = BaseWindow.Create( self.window )
	self.tab:AddPage( "Способности", powers )

	local bkpanelsLabel = Label.Create( powers )
	bkpanelsLabel:SetVisible( true )
	bkpanelsLabel:SetDock( GwenPosition.Left )
	bkpanelsLabel:SetSize( Vector2( 320, 0 ) )

	local scroll_control = ScrollControl.Create( bkpanelsLabel )
	scroll_control:SetScrollable( false, true )
	scroll_control:SetDock( GwenPosition.Fill )
	scroll_control:SetMargin( Vector2( 5, 5 ), Vector2( 2, 5 ) )

	self.buttonPMod = LabeledCheckBox.Create( scroll_control )
	self.buttonPMod:GetLabel():SetText( "Вингсьют" )
	self.buttonPMod:SetSize( Vector2( 300, 20 ) )
	self.buttonPMod:GetLabel():SetTextSize( 15 )
	self.buttonPMod:SetDock( GwenPosition.Top )
	self.buttonPMod:GetCheckBox():SetChecked( self.actvPM )
	self.buttonPMod:GetCheckBox():Subscribe( "CheckChanged",
		function() self.actvPM = not self.actvPM self:GameLoad() end )

	self.buttonLH = LabeledCheckBox.Create( scroll_control )
	if LocalPlayer:GetValue( "LongerGrapple" ) then
		self.buttonLH:GetLabel():SetText( "Дальный крюк (" .. LocalPlayer:GetValue( "LongerGrapple" ) .. "м)" )
		self.buttonLH:GetLabel():SetEnabled( true )
		self.buttonLH:GetCheckBox():SetEnabled( true )
	else
		self.buttonLH:GetLabel():SetText( "Дальный крюк (150м) | [НЕДОСТУПНО]" )
		self.buttonLH:GetLabel():SetEnabled( false )
		self.buttonLH:GetCheckBox():SetEnabled( false )
	end
	self.buttonLH:SetSize( Vector2( 305, 20 ) )
	self.buttonLH:GetLabel():SetTextSize( 15 )
	self.buttonLH:SetDock( GwenPosition.Top )
	self.buttonLH:GetCheckBox():SetChecked( self.actvH )
	self.buttonLH:GetCheckBox():Subscribe( "CheckChanged",
		function() self.actvH = not self.actvH self:GameLoad() end )

	local button = LabeledCheckBox.Create( scroll_control )
	button:GetLabel():SetText( "Гидравлика" )
	button:SetSize( Vector2( 300, 20 ) )
	button:GetLabel():SetTextSize( 15 )
	button:SetDock( GwenPosition.Top )
	button:GetCheckBox():SetChecked( self.actvHu )
	button:GetCheckBox():Subscribe( "CheckChanged",
		function() self.actvHu = not self.actvHu self:GameLoad() end )

	self.flipbutton = LabeledCheckBox.Create( bkpanelsLabel )
	self.spinbutton = LabeledCheckBox.Create( bkpanelsLabel )
	self.rollbutton = LabeledCheckBox.Create( bkpanelsLabel )

	self.rollbutton:SetSize( Vector2( 300, 20 ) )
	self.rollbutton:GetCheckBox():SetEnabled( false )
	self.rollbutton:SetDock( GwenPosition.Bottom )
	self.rollbutton:GetLabel():SetText( "Бочка" )
	self.rollbutton:GetCheckBox():SetChecked( self.roll )
	self.rollbutton:GetCheckBox():Subscribe( "CheckChanged", 
		function()
			self.roll = self.rollbutton:GetCheckBox():GetChecked()
			self:GameLoad()

			if self.roll then
				self.spinbutton:GetCheckBox():SetChecked( false )
				self.flipbutton:GetCheckBox():SetChecked( false )
			end
		end
	)

	self.spinbutton:SetSize( Vector2( 300, 20 ) )
	self.spinbutton:GetCheckBox():SetEnabled( false )
	self.spinbutton:SetDock( GwenPosition.Bottom )
	self.spinbutton:GetLabel():SetText( "Спиннер" )
	self.spinbutton:GetCheckBox():SetChecked( self.spin )
	self.spinbutton:GetCheckBox():Subscribe( "CheckChanged", 
		function()
			self.spin = self.spinbutton:GetCheckBox():GetChecked()
			self:GameLoad()

			if self.spin then
				self.rollbutton:GetCheckBox():SetChecked( false )
				self.flipbutton:GetCheckBox():SetChecked( false )
			end
		end
	)

	self.flipbutton:SetSize( Vector2( 300, 20 ) )
	self.flipbutton:GetCheckBox():SetEnabled( false )
	self.flipbutton:SetDock( GwenPosition.Bottom )
	self.flipbutton:GetLabel():SetText( "Кувырок" )
	self.flipbutton:GetCheckBox():SetChecked( self.flip )
	self.flipbutton:GetCheckBox():Subscribe( "CheckChanged", 
		function()
			self.flip = self.flipbutton:GetCheckBox():GetChecked()
			self:GameLoad()

			if self.flip then
				self.rollbutton:GetCheckBox():SetChecked( false )
				self.spinbutton:GetCheckBox():SetChecked( false )
			end
		end
	)

	self.texterFo = Label.Create( bkpanelsLabel )
	self.texterFo:SetText( "Транспортные трюки (кнопка Y):" )
	self.texterFo:SetDock( GwenPosition.Bottom )
	self.texterFo:SetMargin( Vector2( 0, 0 ), Vector2( 0, 5 ) )
	self.texterFo:SizeToContents()

	local rbkpanelsLabel = Label.Create( powers )
	rbkpanelsLabel:SetVisible( true )
	rbkpanelsLabel:SetDock( GwenPosition.Right )
	rbkpanelsLabel:SetSize( Vector2( 320, 0 ) )
	rbkpanelsLabel:SetMargin( Vector2( 0, 0 ), Vector2( 5, 0 ) )

	self.jpviptip = Label.Create( rbkpanelsLabel )
	self.jpviptip:SetVisible( true )
	self.jpviptip:SetText( "★ Доступно только для VIP" )
	self.jpviptip:SetTextColor( Color.DarkGray )
	self.jpviptip:SetDock( GwenPosition.Top )
	self.jpviptip:SetMargin( Vector2( 0, 3 ), Vector2( 0, 5 ) )
	self.jpviptip:SizeToContents()

	self.buttonJP = Button.Create( rbkpanelsLabel )
	self.buttonJP:SetEnabled( false )
	self.buttonJP:SetText( "Использовать Реактивный ранец" )
	self.buttonJP:SetSize( Vector2( 315, 30 ) )
	self.buttonJP:SetTextSize( 14 )
	self.buttonJP:SetDock( GwenPosition.Top )
	self.buttonJP:SetMargin( Vector2( 0, 3 ), Vector2( 0, 5 ) )
	self.buttonJP:Subscribe( "Press", self, self.GetJetpack )

	self.texterTw = Label.Create( rbkpanelsLabel )
	self.texterTw:SetVisible( false )
	self.texterTw:SetText( "Погода:" )
	self.texterTw:SetDock( GwenPosition.Top )
	self.texterTw:SetMargin( Vector2( 0, 10 ), Vector2( 0, 5 ) )
	self.texterTw:SizeToContents()

	local weathertabsLabel = Label.Create( rbkpanelsLabel )
	weathertabsLabel:SetVisible( true )
	weathertabsLabel:SetDock( GwenPosition.Top )
	weathertabsLabel:SetSize( Vector2( 0, 30 ) )

	self.button = Button.Create( weathertabsLabel )
	self.button:SetVisible( false )
	self.button:SetText( "Ясно" )
	self.button:SetSize( Vector2( 100, 30 ) )
	self.button:SetTextSize( 15 )
	self.button:SetDock( GwenPosition.Left )
	self.button:Subscribe( "Press", self, function() Network:Send( "Clear" ) self:SetWindowVisible( false ) end )

	self.buttonTw = Button.Create( weathertabsLabel )
	self.buttonTw:SetVisible( false )
	self.buttonTw:SetText( "Пасмурно" )
	self.buttonTw:SetSize( Vector2( 100, 30 ) )
	self.buttonTw:SetTextSize( 15 )
	self.buttonTw:SetDock( GwenPosition.Fill )
	self.buttonTw:SetMargin( Vector2( 5, 0 ), Vector2( 5, 0 ) )
	self.buttonTw:Subscribe( "Press", self, function() Network:Send( "Clouds" ) self:SetWindowVisible( false ) end )

	self.buttonTh = Button.Create( weathertabsLabel )
	self.buttonTh:SetVisible( false )
	self.buttonTh:SetText( "Гроза" )
	self.buttonTh:SetSize( Vector2( 100, 30 ) )
	self.buttonTh:SetTextSize( 15 )
	self.buttonTh:SetDock( GwenPosition.Right )
	self.buttonTh:Subscribe( "Press", self, function() Network:Send( "Thunder" ) self:SetWindowVisible( false ) end )

	local nickcolor = BaseWindow.Create( self.window )
	self.tab:AddPage( "Цвет ника", nickcolor )

	local tab_control = TabControl.Create( nickcolor )
	tab_control:SetDock( GwenPosition.Fill )

	self.pcolorPicker = HSVColorPicker.Create( tab_control )
	self.pcolorPicker:SetDock( GwenPosition.Fill )

	self.pcolorPicker:Subscribe( "ColorChanged", function()
		self.pcolor = self.pcolorPicker:GetColor()
		self.colorChanged = true
	end )

	self.pcolorPicker:SetColor( LocalPlayer:GetColor() )
	self.pcolor = self.pcolorPicker:GetColor()

	local setColorBtn = Button.Create( nickcolor )
	setColorBtn:SetText( "Установить цвет »" )
	setColorBtn:SetTextHoveredColor( Color.GreenYellow )
	setColorBtn:SetTextPressedColor( Color.GreenYellow )
	setColorBtn:SetTextSize( 15 )
	setColorBtn:SetSize( Vector2( 0, 30 ) )
	setColorBtn:SetDock( GwenPosition.Bottom )
	setColorBtn:Subscribe( "Up", function()
		Network:Send( "SetPlyColor", { pcolor = self.pcolor } )
		local sound = ClientSound.Create(AssetLocation.Game, {
				bank_id = 20,
				sound_id = 22,
				position = LocalPlayer:GetPosition(),
				angle = Angle()
		})

		sound:SetParameter(0,1)	
		Game:FireEvent( "bm.savecheckpoint.go" )
	end )

	local skysettings = BaseWindow.Create( self.window )
	self.tab:AddPage( "Небо", skysettings )

	local skySettingFo = LabeledCheckBox.Create( skysettings )
	local skySetting = LabeledCheckBox.Create( skysettings )
	local skySettingSe = LabeledCheckBox.Create( skysettings )
	local skySettingTw = LabeledCheckBox.Create( skysettings )
	local skySettingFi = LabeledCheckBox.Create( skysettings )
	local skySettingTh = LabeledCheckBox.Create( skysettings )
	local skySettingAnime = LabeledCheckBox.Create( skysettings )
	local skySettingSi = LabeledCheckBox.Create( skysettings )
	local skySettingSRnb = LabeledCheckBox.Create( skysettings )

	skySettingFo:SetSize( Vector2( 300, 20 ) )
	skySettingFo:SetDock( GwenPosition.Top )
	skySettingFo:GetLabel():SetText( "Космос" )
	skySettingFo:GetLabel():SetTextSize( 15 )
	skySettingFo:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skyFo = skySettingFo:GetCheckBox():GetChecked() end )

	skySetting:SetSize( Vector2( 300, 20 ) )
	skySetting:SetDock( GwenPosition.Top )
	skySetting:GetLabel():SetText( "Епифанцев чистит вилкой" )
	skySetting:GetLabel():SetTextSize( 15 )
	skySetting:GetCheckBox():Subscribe( "CheckChanged",
		function() self.sky = skySetting:GetCheckBox():GetChecked() end )

	skySettingTw:SetSize( Vector2( 300, 20 ) )
	skySettingTw:SetDock( GwenPosition.Top )
	skySettingTw:GetLabel():SetText( "Ahhh" )
	skySettingTw:GetLabel():SetTextSize( 15 )
	skySettingTw:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skyTw = skySettingTw:GetCheckBox():GetChecked() end )

	skySettingFi:SetSize( Vector2( 300, 20 ) )
	skySettingFi:SetDock( GwenPosition.Top )
	skySettingFi:GetLabel():SetText( "Хоррор" )
	skySettingFi:GetLabel():SetTextSize( 15 )
	skySettingFi:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skyFi = skySettingFi:GetCheckBox():GetChecked() end )

	skySettingTh:SetSize( Vector2( 300, 20 ) )
	skySettingTh:SetDock( GwenPosition.Top )
	skySettingTh:GetLabel():SetText( "Пахом" )
	skySettingTh:GetLabel():SetTextSize( 15 )
	skySettingTh:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skyTh = skySettingTh:GetCheckBox():GetChecked() end )

	skySettingSe:SetSize( Vector2( 300, 20 ) )
	skySettingSe:SetDock( GwenPosition.Top )
	skySettingSe:GetLabel():SetText( "Мастер подземелий" )
	skySettingSe:GetLabel():SetTextSize( 15 )
	skySettingSe:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skySi = skySettingSe:GetCheckBox():GetChecked() end )

	skySettingAnime:SetSize( Vector2( 300, 20 ) )
	skySettingAnime:SetDock( GwenPosition.Top )
	skySettingAnime:GetLabel():SetText( "Аниме" )
	skySettingAnime:GetLabel():SetTextSize( 15 )
	skySettingAnime:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skySe = skySettingAnime:GetCheckBox():GetChecked() if self.skySe then self.timer = Timer() else self.timer = nil end end )

	skySettingSi:SetSize( Vector2( 300, 20 ) )
	skySettingSi:SetDock( GwenPosition.Top )
	skySettingSi:GetLabel():SetText( "Цвет ↓" )
	skySettingSi:GetLabel():SetTextSize( 15 )
	skySettingSi:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skyColor = skySettingSi:GetCheckBox():GetChecked() end )

	local tab_control = TabControl.Create( skysettings )
	tab_control:SetDock( GwenPosition.Fill )

	self.toneS1Picker = HSVColorPicker.Create()
	tab_control:AddPage( "▨ Цвет", self.toneS1Picker )
	self.toneS1Picker:SetDock( GwenPosition.Fill )

	skySettingSRnb:SetSize( Vector2( 300, 20 ) )
	skySettingSRnb:SetDock( GwenPosition.Bottom )
	skySettingSRnb:GetLabel():SetText( "Переливания цветов неба" )
	skySettingSRnb:GetLabel():SetTextSize( 13 )
	skySettingSRnb:GetCheckBox():Subscribe( "CheckChanged",
		function() self.skyRainbow = skySettingSRnb:GetCheckBox():GetChecked() if self.skyRainbow then self.rT = Timer() else self.rT = nil end end )
end

function Settings:GameRender()
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end

	if self.skyFo then
		self.BackgroundImageFo:SetPosition( Vector2.Zero )
		self.BackgroundImageFo:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImageFo:Draw()
	end

	if self.sky then
		self.BackgroundImage:SetPosition( Vector2.Zero )
		self.BackgroundImage:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImage:Draw()
	end

	if self.skyFi then
		self.BackgroundImageFi:SetPosition( Vector2.Zero )
		self.BackgroundImageFi:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImageFi:Draw()
	end

	if self.skyColor then
		if self.skyRainbow and self.rT then
			h = ( 0.01 * self.rT:GetMilliseconds() ) * 5
			color = Color.FromHSV( h % 360, 1, 1 )
			Render:FillArea( Vector2.Zero, Render.Size, color + Color( 0, 0, 0, 100 ) )
		else
			Render:FillArea( Vector2.Zero, Render.Size, self.toneS1Picker:GetColor() + Color( 0, 0, 0, 100 ) )
		end
	end

	if self.skyTw then
		self.BackgroundImageTw:SetPosition( Vector2.Zero )
		self.BackgroundImageTw:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImageTw:Draw()
	end

	if self.skySi then
		self.BackgroundImageSi:SetPosition( Vector2.Zero )
		self.BackgroundImageSi:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImageSi:Draw()
	end

	if self.skySe then
		self.BackgroundImageSe:SetPosition( Vector2.Zero )
		self.BackgroundImageSe:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImageSe:Draw()
		if self.timer then
			if self.timer:GetSeconds() <= 1 then
				self.BackgroundImageSe = Image.Create( AssetLocation.Resource, "Anime1" )
			else
				self.BackgroundImageSe = Image.Create( AssetLocation.Resource, "Anime2" )
			end
			if self.timer:GetSeconds() >= 2 then
				self.timer:Restart()
			end
		end
	end

	if self.skyTh then
		self.BackgroundImageTh:SetPosition( Vector2.Zero )
		self.BackgroundImageTh:SetSize( Vector2( Render.Width, Render.Height ) )
		self.BackgroundImageTh:Draw()
	end
end

function Settings:GameLoad()
	Events:Fire( "GetOption", {
		actPM = self.actvPM,
		actH = self.actvH,
		actHu = self.actvHu,
		actCH = self.actvCH,
		actSn = self.actvSn,
		roll = self.roll,
		spin = self.spin,
		flip = self.flip
	} )
end

function Settings:Open()
	self:SetWindowVisible( not self.active )
	if LocalPlayer:GetValue( "JesusModeEnabled" ) then
		self.JesusVisButton:SetVisible( true )
	else
		self.JesusVisButton:SetVisible( false )
	end

	if LocalPlayer:GetValue( "LongerGrapple" ) then
		self.buttonLH:GetLabel():SetText( "Дальный крюк (" .. LocalPlayer:GetValue( "LongerGrapple" ) .. "м)" )
		self.buttonLH:GetLabel():SetEnabled( true )
		self.buttonLH:GetCheckBox():SetEnabled( true )
	else
		self.buttonLH:GetLabel():SetText( "Дальный крюк (150м) | [НЕДОСТУПНО]" )
		self.buttonLH:GetLabel():SetEnabled( false )
		self.buttonLH:GetCheckBox():SetEnabled( false )
	end

	if LocalPlayer:GetValue( "Tag" ) == "Creator" or LocalPlayer:GetValue( "Tag" ) == "GlAdmin" or LocalPlayer:GetValue( "Tag" ) == "Admin"
		or LocalPlayer:GetValue( "Tag" ) == "AdminD" or LocalPlayer:GetValue( "Tag" ) == "ModerD" or LocalPlayer:GetValue( "Tag" ) == "VIP" then
		self.texterTw:SetVisible( true )
		self.button:SetVisible( true )
		self.buttonTw:SetVisible( true )
		self.buttonTh:SetVisible( true )

		self.rollbutton:GetCheckBox():SetEnabled( true )
		self.spinbutton:GetCheckBox():SetEnabled( true )
		self.flipbutton:GetCheckBox():SetEnabled( true )
		self.buttonJP:SetEnabled( true )
		self.jpviptip:SetVisible( false )
		self.texterTw:SetPosition( Vector2( self.window:GetSize().x - 350, 50 ) )
		self.button:SetPosition( Vector2( self.texterTw:GetPosition().x, self.texterTw:GetPosition().y + 20 ) )
		self.buttonTw:SetPosition( Vector2( self.button:GetPosition().x + 105, self.texterTw:GetPosition().y + 20 ) )
		self.buttonTh:SetPosition( Vector2( self.buttonTw:GetPosition().x + 105, self.texterTw:GetPosition().y + 20 ) )
	else
		self.buttonJP:SetEnabled( false )
		self.jpviptip:SetVisible( true )
		self.texterTw:SetPosition( Vector2( self.window:GetSize().x - 350, 70 ) )
		self.button:SetPosition( Vector2( self.texterTw:GetPosition().x, self.texterTw:GetPosition().y + 20 ) )
		self.buttonTw:SetPosition( Vector2( self.button:GetPosition().x + 105, self.texterTw:GetPosition().y + 20 ) )
		self.buttonTh:SetPosition( Vector2( self.buttonTw:GetPosition().x + 105, self.texterTw:GetPosition().y + 20 ) )
	end

	if self.active then
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 382,

			position = Camera:GetPosition(),
			angle = Angle()
		})
	else
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 383,

			position = Camera:GetPosition(),
			angle = Angle()
		})
	end
end

function Settings:LocalPlayerInput( args )
    if self.active then
		if args.input == Action.GuiPause then
			self:SetWindowVisible( false )
		end
		if self.actions[args.input] then
			return false
		end
	end
end

function Settings:OpenSettingsMenu( args )
	if Game:GetState() ~= GUIState.Game then return end
	self:Open()
end

function Settings:CloseSettingsMenu( args )
	if Game:GetState() ~= GUIState.Game then return end
	if self.window:GetVisible() == true then
		self:SetWindowVisible( false )
	end
end

function Settings:WindowClosed( args )
	self:SetWindowVisible( false )
	ClientEffect.Create(AssetLocation.Game, {
		effect_id = 383,

		position = Camera:GetPosition(),
		angle = Angle()
	})
end

function Settings:Render()
	local is_visible = self.active and (Game:GetState() == GUIState.Game)

	if self.window:GetVisible() ~= is_visible then
		self.window:SetVisible( is_visible )
	end
end

function Settings:SetWindowVisible( visible )
    if self.active ~= visible then
		self.active = visible
		self.window:SetVisible( visible )
		Mouse:SetVisible( visible )
	end
end

function Settings:ToggleAim()
	self.aim = not self.aim
	if self.aim then
		if self.RenderEvent then
			Events:Unsubscribe( self.RenderEvent )
			self.RenderEvent = nil
		end
		Game:FireEvent("gui.aim.show")
		self.actvCH = self.before
		self.before = nil
		self:GameLoad()
	else
		if not self.RenderEvent then
			self.RenderEvent = Events:Subscribe( "Render", self, self.Aim )
		end
		if self.actvCH then
			self.actvCH = false
			self.before = true
			self:GameLoad()
		end
	end
end

function Settings:Aim()
	Game:FireEvent("gui.aim.hide")
end

function Settings:GetJetpack()
	Events:Fire( "UseJetpack" )
	self:SetWindowVisible( false )
end

function Settings:ResetDone()
	self.buttonSPOff:SetEnabled( false )
	self.buttonSPOff:SetText( "Позиция сброшена. Перезайдите в игру." )
end

function Settings:KeyHide( args )
	if args.key == VirtualKey.F11 then
		if self.gethide then
			self.hidetext:SetVisible( false )
		else
			self.hidetext:SetVisible( true )
		end
		LocalPlayer:SetValue( "ClockVisible", not LocalPlayer:GetValue( "ClockVisible" ) )
		LocalPlayer:SetValue( "BestRecordVisible", not LocalPlayer:GetValue( "BestRecordVisible" ) )
		LocalPlayer:SetValue( "PassiveModeVisible", not LocalPlayer:GetValue( "PassiveModeVisible" ) )
		LocalPlayer:SetValue( "JesusModeVisible", not LocalPlayer:GetValue( "JesusModeVisible" ) )
		LocalPlayer:SetValue( "KillFeedVisible", not LocalPlayer:GetValue( "KillFeedVisible" ) )
		LocalPlayer:SetValue( "PlayersMarkersVisible", not LocalPlayer:GetValue( "PlayersMarkersVisible" ) )
		LocalPlayer:SetValue( "LongerGrappleVisible", not LocalPlayer:GetValue( "LongerGrappleVisible" ) )
		LocalPlayer:SetValue( "JobsMarkersVisible", not LocalPlayer:GetValue( "JobsMarkersVisible" ) )
		self.gethide = not self.gethide
		self:GameLoad()
	end
end

settings = Settings()