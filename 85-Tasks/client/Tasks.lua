class 'Tasks'

function Tasks:__init()
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

    self.dedmimage = Image.Create( AssetLocation.Resource, "DedMImage" )

    self.active = false

    self.huntkillsneeded = 666
    self.fireworksneeded = 666
    self.flyingrecordneeded = 666
    self.tetrisrecordneeded = 666
    self.driftrecordneeded = 666
    self.tronwinsneeded = 666

    Network:Send( "GetNeededs" )

    self.unlock = "√"

    self.huntkills = "x"
    self.huntkillsC = Color.Silver

    self.tronwins = "x"
    self.tronwinsC = Color.Silver

    self.tetrisrecord = "x"
    self.tetrisrecordC = Color.Silver

    self.driftrecord = "x"
    self.driftrecordC = Color.Silver

    self.flyingrecord = "x"
    self.flyingrecordC = Color.Silver

    self.fireworkstossed = "x"
    self.fireworkstossedC = Color.Silver

    self.bloozing = "x"
    self.bloozingC = Color.Silver

    self.window = Window.Create()
    self.window:SetSizeRel( Vector2( 0.5, 0.5 ) )
    self.window:SetMinimumSize( Vector2( 600, 442 ) )
    self.window:SetPositionRel( Vector2( 0.72, 0.5 ) - self.window:GetSizeRel()/2 )
    self.window:SetVisible( self.active )
    self.window:SetTitle( "▧ Ежедневные задания" )
    self.window:Subscribe( "WindowClosed", self, self.Open )

    self.LeftLabel = Label.Create( self.window )
	self.LeftLabel:SetDock( GwenPosition.Fill )
	self.LeftLabel:SetMargin( Vector2( 0, 2 ), Vector2( 0, 4 ) )

    self.prize_btn = Button.Create( self.LeftLabel )
    self.prize_btn:SetDock( GwenPosition.Bottom )
    self.prize_btn:SetText( "Получить награду " .. "( $10.000 )" )
    self.prize_btn:SetSize( Vector2( 0, 30 ) )
    self.prize_btn:Subscribe( "Press", self, self.GetPrize )

    self.hidetexttip = Label.Create( self.LeftLabel )
	self.hidetexttip:SetText( "Выполняй эти задания, чтобы получить свой приз. Задания обновляются каждый день." )
	self.hidetexttip:SetDock( GwenPosition.Top )
	self.hidetexttip:SetMargin( Vector2( 0, 2 ), Vector2( 0, 4 ) )
    self.hidetexttip:SizeToContents()

    self.list = SortedList.Create( self.LeftLabel )
	self.list:SetDock( GwenPosition.Fill )
	self.list:SetBackgroundVisible( false )
	self.list:AddColumn( "Задание:" )
    self.list:AddColumn( "√/x", 50 )

    Events:Subscribe( "Render", self, self.Render )
    Events:Subscribe( "Lang", self, self.Lang )
    Network:Subscribe( "NewNeededs", self, self.NewNeededs )
    Events:Subscribe( "OpenDedMorozMenu", self, self.OpenDedMorozMenu )
    Events:Subscribe( "CloseDedMorozMenu", self, self.CloseDedMorozMenu )
end

function Tasks:Lang()
    self.window:SetTitle( "▧ Daily Tasks" )
    self.hidetexttip:SetText( "Complete these tasks to get your prize. Quests are updated every day." )
    self.prize_btn:SetText( "Get award " .. "( $10.000 )" )
end

function Tasks:NewNeededs( args )
    self.huntkillsneeded = args.huntkillsneeded
    self.fireworksneeded = args.fireworksneeded
    self.flyingrecordneeded = args.flyingrecordneeded
    self.tetrisrecordneeded = args.tetrisrecordneeded
    self.driftrecordneeded = args.driftrecordneeded
    self.tronwinsneeded = args.tronwinsneeded
end

function Tasks:OpenDedMorozMenu()
    if Game:GetState() ~= GUIState.Game then return end
    self:Open()
end

function Tasks:CloseDedMorozMenu()
    if Game:GetState() ~= GUIState.Game then return end
	if self.window:GetVisible() == true then
        self:SetWindowVisible( false )
        self.list:Clear()
		if self.LocalPlayerInputEvent then
			Events:Unsubscribe( self.LocalPlayerInputEvent )
			self.LocalPlayerInputEvent = nil
		end
	end
end

function Tasks:Open()
    self:SetWindowVisible( not self.active )

    if self.active then
        if LocalPlayer:GetValue( "HuntKills" ) then
            if LocalPlayer:GetValue( "HuntKills" ) >= self.huntkillsneeded then
                self.huntkills = self.unlock
                self.huntkillsC = Color.Chartreuse
            end
        end

        if LocalPlayer:GetValue( "TronWins" ) then
            if LocalPlayer:GetValue( "TronWins" ) >= self.tronwinsneeded then
                self.tronwins = self.unlock
                self.tronwinsC = Color.Chartreuse
            end
        end
    
        if LocalPlayer:GetValue( "TetrisRecord" ) then
            if LocalPlayer:GetValue( "TetrisRecord" ) >= self.tetrisrecordneeded then
                self.tetrisrecord = self.unlock
                self.tetrisrecordC = Color.Chartreuse
            end
        end

        if LocalPlayer:GetValue( "DriftRecord" ) then
            if LocalPlayer:GetValue( "DriftRecord" ) >= self.driftrecordneeded then
                self.driftrecord = self.unlock
                self.driftrecordC = Color.Chartreuse
            end
        end

        if LocalPlayer:GetValue( "FlyingRecord" ) then
            if LocalPlayer:GetValue( "FlyingRecord" ) >= self.flyingrecordneeded then
                self.flyingrecord = self.unlock
                self.flyingrecordC = Color.Chartreuse
            end
        end

        if LocalPlayer:GetValue( "FireworksTossed" ) then
            if LocalPlayer:GetValue( "FireworksTossed" ) >= self.fireworksneeded then
                self.fireworkstossed = self.unlock
                self.fireworkstossedC = Color.Chartreuse
            end
        end

        if LocalPlayer:GetValue( "Bloozing" ) then
            if LocalPlayer:GetValue( "Bloozing" ) >= 1 then
                self.bloozing = self.unlock
                self.bloozingC = Color.Chartreuse
            end
        end

        if LocalPlayer:GetValue( "Prize" ) ~= 0 then
            if LocalPlayer:GetValue( "HuntKills" ) >= self.huntkillsneeded and LocalPlayer:GetValue( "TronWins" ) >= self.tronwinsneeded and LocalPlayer:GetValue( "TetrisRecord" ) >= self.tetrisrecordneeded and LocalPlayer:GetValue( "DriftRecord" ) >= self.driftrecordneeded and LocalPlayer:GetValue( "FlyingRecord" ) >= self.flyingrecordneeded and LocalPlayer:GetValue( "FireworksTossed" ) >= self.fireworksneeded and LocalPlayer:GetValue( "Bloozing" ) >= 1 then
                self.prize_btn:SetEnabled( true )
            else
                self.prize_btn:SetEnabled( false )
            end
        else
            self.prize_btn:SetEnabled( false )
        end

        local item = self.list:AddItem( "Убейте " .. self.huntkillsneeded .. " человек в режиме 'Охота'" )
        item:SetCellText( 1, self.huntkills )
        item:SetTextColor( self.huntkillsC )
        item:SetToolTip( "Зайдите в главное меню сервера, затем нажмите Другие режимы и выберете режим 'Охота'" )
        local item = self.list:AddItem( "Выйграте в режиме 'Трон' более " .. self.tronwinsneeded .. "-х раз" )
        item:SetCellText( 1, self.tronwins )
        item:SetTextColor( self.tronwinsC )
        item:SetToolTip( "Введите команду /tron в игровой чат, чтобы войти в лобби" )
        local item = self.list:AddItem( "Наберите " .. self.tetrisrecordneeded .. "+ очков в тетрисе" )
        item:SetCellText( 1,  self.tetrisrecord )
        item:SetTextColor( self.tetrisrecordC )
        item:SetToolTip( "Нажмите на кнопку □□□ в меню сервера, чтобы поиграть в тетрис" )
        local item = self.list:AddItem( "Наберите " .. self.driftrecordneeded .. "+ очков хорошечного дрифта" )
        item:SetCellText( 1,  self.driftrecord )
        item:SetTextColor( self.driftrecordC )
        local item = self.list:AddItem( "Наберите " .. self.flyingrecordneeded .. "+ очков полёта на вингсьюте" )
        item:SetCellText( 1,  self.flyingrecord )
        item:SetTextColor( self.flyingrecordC )
        item:SetToolTip( "Нажмите на Q во время полёта, чтобы раскрыть вингсьют" )
        local item = self.list:AddItem( "Расслабьтесь и бухните :)" )
        item:SetCellText( 1,  self.bloozing )
        item:SetTextColor( self.bloozingC )
        item:SetToolTip( "Зайдите в Черный рынок > Остальное > Действия, а затем нажмите кнопку 'Бухнуть'" )
        local item = self.list:AddItem( "Время фейерверков! Взорвите " .. self.fireworksneeded .. " осколочных гранат ( ͡° ͜ʖ ͡°)" )
        item:SetCellText( 1,  self.fireworkstossed )
        item:SetTextColor( self.fireworkstossedC )
        item:SetToolTip( "Нажмите на G, чтобы выбрать гранату" )

		if not self.LocalPlayerInputEvent then
			self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )
		end
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 382,

			position = Camera:GetPosition(),
			angle = Angle()
		})
    else
        self.list:Clear()
		if self.LocalPlayerInputEvent then
			Events:Unsubscribe( self.LocalPlayerInputEvent )
			self.LocalPlayerInputEvent = nil
		end
		ClientEffect.Play(AssetLocation.Game, {
			effect_id = 383,

			position = Camera:GetPosition(),
			angle = Angle()
		})
	end
end

function Tasks:GetPrize( args )
    self.prize_btn:SetEnabled( false )
    Network:Send( "GetPrize" )
end

function Tasks:LocalPlayerInput( args )
    if args.input == Action.GuiPause then
        self:CloseDedMorozMenu()
    end
	if self.actions[args.input] then
		return false
	end
end

function Tasks:Render()
	local is_visible = self.active and (Game:GetState() == GUIState.Game)

	if self.window:GetVisible() ~= is_visible then
		self.window:SetVisible( is_visible )
	end
end

function Tasks:SetWindowVisible( visible )
    if self.active ~= visible then
		self.active = visible
		self.window:SetVisible( visible )
		Mouse:SetVisible( visible )
	end
end

tasks = Tasks()