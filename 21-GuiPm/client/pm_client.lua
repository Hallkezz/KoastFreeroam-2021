class "PM"

function PM:__init( player )
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

	self.dmoode = false

	self.newmsgtxt = "Новое сообщение!"
	self.sendermsgtxt = "Отправитель: "

	self.messages = {}
	self.GUI = {}
	self.GUI.window = Window.Create()
	self.GUI.window:SetSizeRel( Vector2( 0.4, 0.5 ) )
	self.GUI.window:SetMinimumSize( Vector2( 600, 442 ) )
	self.GUI.window:SetPositionRel( Vector2( 0.7, 0.5 ) - self.GUI.window:GetSizeRel()/2 )
	self.GUI.window:SetTitle( "[▼] Личные Сообщения" )
	self.GUI.window:SetVisible( false )

	self.GUI.list = SortedList.Create( self.GUI.window )
	self.GUI.list:SetDock( GwenPosition.Left )
	self.GUI.list:SetWidthRel( 0.4 )
	self.GUI.list:AddColumn( "Игрок" )
	self.GUI.list:Subscribe( "RowSelected", self, self.loadMessages )

	self.GUI.PMMessagesControlLabel = Label.Create( self.GUI.window )
	self.GUI.PMMessagesControlLabel:SetDock( GwenPosition.Top )
	self.GUI.PMMessagesControlLabel:SetHeight( 25 )
	self.GUI.PMMessagesControlLabel:SetMargin( Vector2( 10, 5 ), Vector2( 5, 5 ) )

	self.GUI.labelM = Label.Create( self.GUI.PMMessagesControlLabel )
	self.GUI.labelM:SetDock( GwenPosition.Left )
	self.GUI.labelM:SetAlignment( GwenPosition.CenterV )
	self.GUI.labelM:SetText( "Переписка:" )
	self.GUI.labelM:SetTextSize( 14 )
	self.GUI.labelM:SizeToContents()

	self.GUI.clear = Button.Create( self.GUI.PMMessagesControlLabel )
	self.GUI.clear:SetDock( GwenPosition.Right )
	self.GUI.clear:SetSize( Vector2( 80, 25 ) )
	self.GUI.clear:SetText( "Очистить" )
	self.GUI.clear:SetTextHoveredColor( Color.DarkOrange )
	self.GUI.clear:Subscribe( "Press", self, self.clearMessage )

	self.GUI.PMDistrub = Button.Create( self.GUI.PMMessagesControlLabel )
	self.GUI.PMDistrub:SetDock( GwenPosition.Right )
	self.GUI.PMDistrub:SetMargin( Vector2( 0, 0 ), Vector2( 5, 0 ) )
	self.GUI.PMDistrub:SetSize( Vector2( 100, 25 ) )
	self.GUI.PMDistrub:SetText( "Не беспокоить" )
	if LocalPlayer:GetValue( "PMDistrub" ) then
		self.GUI.PMDistrub:SetTextNormalColor( Color.DarkOrange )
		self.GUI.PMDistrub:SetTextHoveredColor( Color.DarkOrange )
	else
		self.GUI.PMDistrub:SetTextNormalColor( Color.White )
		self.GUI.PMDistrub:SetTextHoveredColor( Color.White )
	end
	self.GUI.PMDistrub:Subscribe( "Press", self, self.ToggleDistrub )

	self.GUI.drawLine = Rectangle.Create( self.GUI.window )
	self.GUI.drawLine:SetDock( GwenPosition.Top )
	self.GUI.drawLine:SetMargin( Vector2( 10, 0 ), Vector2( 10, 0 ) )
	self.GUI.drawLine:SetHeight( 1 )
	self.GUI.drawLine:SetColor( Color.White )

	self.GUI.PMMessagesScroll = ScrollControl.Create( self.GUI.window )
	self.GUI.PMMessagesScroll:SetDock( GwenPosition.Fill )
	self.GUI.PMMessagesScroll:SetScrollable( false, true )
	self.GUI.PMMessagesScroll:SetMargin( Vector2( 10, 8 ), Vector2( 5, 5 ) )

	self.GUI.messagesLabel = Label.Create( self.GUI.PMMessagesScroll )
	self.GUI.messagesLabel:SetText( "" )
	self.GUI.messagesLabel:SetDock( GwenPosition.Fill )
	self.GUI.messagesLabel:SetWrap( true )

	self.GUI.PMMessageTypingLabel = Label.Create( self.GUI.window )
	self.GUI.PMMessageTypingLabel:SetDock( GwenPosition.Bottom )
	self.GUI.PMMessageTypingLabel:SetHeightRel( 0.065 )
	self.GUI.PMMessageTypingLabel:SetMargin( Vector2( 10, 0 ), Vector2( 5, 5 ) )

	self.GUI.message = TextBox.Create( self.GUI.PMMessageTypingLabel )
	self.GUI.message:SetText( "" )
	self.GUI.message:SetDock( GwenPosition.Fill )
	self.GUI.message:SetMargin( Vector2( 0, 2 ), Vector2( 5, 2 ) )
	self.GUI.message:Subscribe( "ReturnPressed", self, self.sendMessage )
	self.GUI.message:Subscribe( "TextChanged", self, self.ChangelLText )
	self.GUI.message:Subscribe( "Focus", self, self.Focus )
	self.GUI.message:Subscribe( "Blur", self, self.Blur )

	self.GUI.send = Button.Create( self.GUI.PMMessageTypingLabel )
	self.GUI.send:SetText( ">" )
	self.GUI.send:SetDock( GwenPosition.Right )
	self.GUI.send:SetWidth( 70 )
	self.GUI.send:Subscribe( "Press", self, self.sendMessage )

	self.GUI.labelL = Label.Create( self.GUI.window )
	self.GUI.labelL:SetText( "0/300" )
	self.GUI.labelL:SetDock( GwenPosition.Bottom )
	self.GUI.labelL:SetMargin( Vector2( 10, 0 ), Vector2( 0, 0 ) )
	self.GUI.labelL:SizeToContents()

	self.GUI.window:Subscribe( "WindowClosed", self, self.CloseWindow )
	self.playerToRow = {}
	for player in Client:GetPlayers() do
		self:addPlayerToList ( player )
	end

	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "PlayerJoin", self, self.playerJoin )
	Events:Subscribe( "PlayerQuit", self, self.playerQuit )
	Events:Subscribe( "OpenGuiPm", self, self.OpenGuiPm )
	Events:Subscribe( "CloseGuiPm", self, self.CloseGuiPm )
	Events:Subscribe( "LocalPlayerInput", self, self.localPlayerInput )
	Network:Subscribe( "PM.notification", self, self.notification )
	Network:Subscribe( "PM.addMessage", self, self.addMessage )
end

function PM:Lang()
	self.GUI.window:SetTitle( "[▼] Private Messages" )
	self.GUI.labelM:SetText( "Messages:" )
	self.GUI.clear:SetText( "Clear" )
	self.GUI.PMDistrub:SetText( "Do not disturb" )

	self.newmsgtxt = "New message!"
	self.sendermsgtxt = "Sender: "
end

function PM:ChangelLText()
	self.GUI.labelL:SetText( self.GUI.message:GetText():len() .. "/300" )
	if self.GUI.message:GetText():len() >= 300 then
		self.GUI.labelL:SetTextColor( Color.Red )
	else
		self.GUI.labelL:SetTextColor( Color.White )
	end
end

function PM:CloseWindow()
	Mouse:SetVisible( false )
	ClientEffect.Create(AssetLocation.Game, {
		effect_id = 383,

		position = Camera:GetPosition(),
		angle = Angle()
	})
end

function PM:OpenGuiPm()
	if Game:GetState() ~= GUIState.Game then return end

	ClientEffect.Play(AssetLocation.Game, {
		effect_id = 382,

		position = Camera:GetPosition(),
		angle = Angle()
	})

	self.GUI.window:SetVisible( not self.GUI.window:GetVisible() )
	if self.GUI.window:GetVisible() == true then
		self:refreshList()
	end
	Mouse:SetVisible( self.GUI.window:GetVisible() )
end

function PM:CloseGuiPm()
	if Game:GetState() ~= GUIState.Game then return end
	if self.GUI.window:GetVisible() == true then
		self.GUI.window:SetVisible( false )
	end
	Mouse:SetVisible( false )
end

function PM:ToggleDistrub()
	self.dmoode = not LocalPlayer:GetValue( "PMDistrub" )
	Network:Send( "ChangePmMode", { dvalue = self.dmoode } )
	if LocalPlayer:GetValue( "PMDistrub" ) then
		self.GUI.PMDistrub:SetTextNormalColor( Color.White )
		self.GUI.PMDistrub:SetTextHoveredColor( Color.White )
	else
		self.GUI.PMDistrub:SetTextNormalColor( Color.DarkOrange )
		self.GUI.PMDistrub:SetTextHoveredColor( Color.DarkOrange )
	end
end

function PM:localPlayerInput( args )
	if ( self.GUI.window:GetVisible() and Game:GetState() == GUIState.Game ) then
		if args.input == Action.GuiPause then
			self.GUI.window:SetVisible( false )
			Mouse:SetVisible( false )
		end

		if self.focused then
			return false
		else
			if self.actions[args.input] then
				return false
			end
		end
	end
end

function PM:Focus()
	self.focused = true
end

function PM:Blur()
	self.focused = nil
end

function PM:addPlayerToList( player )
	local item = self.GUI.list:AddItem( tostring ( player:GetName() ) )
	local color = player:GetColor()

	if LocalPlayer:IsFriend( player ) then
		item:SetToolTip( "Друг" )
	end

	item:SetTextColor( color )
	item:SetVisible( true )
	item:SetDataObject( "id", player )
	self.playerToRow [ player ] = item
end

function PM:playerJoin( args )
	self:addPlayerToList( args.player )
end

function PM:playerQuit( args )
	if ( self.playerToRow [ args.player ] ) then
		self.GUI.list:RemoveItem( self.playerToRow [ args.player ] )
		self.playerToRow [ args.player ] = nil
	end
end

function PM:loadMessages()
	local row = self.GUI.list:GetSelectedRow()
	if ( row ~= nil ) then
		local player = row:GetDataObject( "id" )
		self.GUI.messagesLabel:SetText( "" )
		if ( self.messages [ tostring( player:GetSteamId() ) ] ) then
			for index, msg in ipairs( self.messages [ tostring ( player:GetSteamId() ) ] ) do
				if IsValid( msg ) then
					if ( index > 1 ) then
						self.GUI.messagesLabel:SetText( self.GUI.messagesLabel:GetText() .."\n".. tostring ( msg ) )
					else
						self.GUI.messagesLabel:SetText( tostring ( msg ) )
					end
				end
			end
		end
		self.GUI.messagesLabel:SizeToContents()
	end
end

function PM:notification( args )
	Events:Fire( "SendNotification", { txt = self.newmsgtxt, image = "Information", subtxt = self.sendermsgtxt .. args.msgsender } )
end

function PM:addMessage( data )
	if ( data.player ) then
		if ( not self.messages [ tostring ( data.player:GetSteamId() ) ] ) then
			self.messages [ tostring ( data.player:GetSteamId() ) ] = {}
		end
		local row = self.GUI.list:GetSelectedRow()
		if ( row ~= nil ) then
			local player = row:GetDataObject( "id" )
			if ( data.player == player ) then
				if ( #self.messages [ tostring( data.player:GetSteamId() ) ] > 0 ) then
					self.GUI.messagesLabel:SetText( self.GUI.messagesLabel:GetText() .."\n".. tostring ( data.text ) )
				else
					self.GUI.messagesLabel:SetText( tostring ( data.text ) )
				end
				self.GUI.messagesLabel:SizeToContents()
			end
		end
		table.insert ( self.messages [ tostring ( data.player:GetSteamId() ) ], data.text )
	end
end

function PM:sendMessage()
	local row = self.GUI.list:GetSelectedRow()
	if ( row ~= nil ) then
		local player = row:GetDataObject( "id" )
		if ( player ) then
			local text = self.GUI.message:GetText()
			if self.GUI.message:GetText():len() <= 300 then
				if ( text ~= "" ) then
					Network:Send( "PM.send", { player = player, text = text } )
					self.GUI.message:SetText( "" )
					self.GUI.message:Focus()
				end
			else
				Chat:Print( "[Сообщения] ", Color.White, "Вы привысили допустимый лимит!", Color.DarkGray )
			end
		else
			Chat:Print("[Сообщения] ", Color.White, "Игрок не в сети!", Color.DarkGray )
		end
	else
		Chat:Print( "[Сообщения] ", Color.White, "Игрок не выбран!", Color.DarkGray )
	end
end

function PM:clearMessage()
	self.GUI.messagesLabel:SetText( "Сообщения очищены." )
end

function PM:refreshList()
	self.GUI.list:Clear()
	self.playerToRow = {}
	--self:addPlayerToList ( LocalPlayer )
	for player in Client:GetPlayers() do
		self:addPlayerToList( player )
	end
end

Events:Subscribe( "ModuleLoad",
	function()
		PM()
	end
)