class 'BetterChat'

function BetterChat:__init()
	Events:Subscribe( "OpenChatMenu", self, self.OpenChatMenu )
	Events:Subscribe( "Lang", self, self.Lang )
	Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "Render", self, self.Render )

	self.name = "Режим чата: "
	self.nameTw = "  (Нажмите 'H', чтобы сменить)"
	self.tiptext = "Двигайте мышь, чтобы изменить позицию чата | Нажмите ЛКМ, чтобы применить изменения"

	self.toggle = 0
	self.text = "Общий"
	self.tGlobal = "Общий"
	self.tLocal = "Локальный"
	self.tPrefix = "Префикс"
	self.chModeMsg = "Режим чата переключён на "

	self.customchatpos = Chat:GetPosition()

	Network:Subscribe( "ApplyChatPos", self, self.ApplyChatPos )
	Network:Send( "toggle", self.toggle )
end

function BetterChat:Lang()
	self.name = "Chat mode: "
	self.nameTw = "  (Press 'H' to change)"
	self.text = "Global"
	self.tGlobal = "Global"
	self.tLocal = "Local"
	self.tPrefix = "Prefix"
	self.chModeMsg = "Chat mode changed on "
	self.tiptext = "Move mouse to change chat position | LB to apply changes"
end

function BetterChat:ApplyChatPos( args )
	self.customchatpos = Vector2( args.sqlchatposX, args.sqlchatposY )
	Chat:SetPosition( self.customchatpos )
	if not self.ResolutionChangeEvent then
		self.ResolutionChangeEvent = Events:Subscribe( "ResolutionChange", self, self.ResolutionChange )
	end
end

function BetterChat:LocalPlayerInput()
	return false
end

function BetterChat:OpenChatMenu()
	if not self.window then
		self.window = Window.Create()
		self.window:SetSize( Vector2( 270, 125 ) )
		self.window:SetPosition( (Render.Size - self.window:GetSize())/2 )
		self.window:SetTitle( "Настройка чата" )
		self.window:Subscribe( "WindowClosed", self, self.CloseWindow )
		Mouse:SetVisible( true )

		local possettbutton = Button.Create( self.window )
		possettbutton:SetDock( GwenPosition.Top )
		possettbutton:SetHeight( 30 )
		possettbutton:SetMargin( Vector2( 0, 2 ), Vector2( 0, 5 ) )
		possettbutton:SetText( "Настроить позицию" )
		possettbutton:Subscribe( "Press", self, self.ChatPosChanger )

		local resetbutton = Button.Create( self.window )
		resetbutton:SetDock( GwenPosition.Top )
		resetbutton:SetHeight( 30 )
		resetbutton:SetMargin( Vector2( 0, 0 ), Vector2( 0, 5 ) )
		resetbutton:SetText( "Сбросить позицию" )
		resetbutton:Subscribe( "Press", self, self.ChatPosReset )
		self.LocalPlayerInputEvent = Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )

		local joinmessagesbutton = LabeledCheckBox.Create( self.window )
		joinmessagesbutton:GetLabel():SetText( "Показывать подключения игроков" )
		joinmessagesbutton:SetDock( GwenPosition.Top )
		if LocalPlayer:GetValue( "VisibleJoinMessages" ) then
			joinmessagesbutton:GetCheckBox():SetChecked( true )
		else
			joinmessagesbutton:GetCheckBox():SetChecked( false )
		end
		joinmessagesbutton:GetCheckBox():Subscribe( "CheckChanged", function() Network:Send( "ChangeChatSettings" ) end )
	else
		self:CloseWindow()
	end
end

function BetterChat:CloseWindow()
	Mouse:SetVisible( false )
	if self.window then
		self.window:Remove()
		self.window = nil
		Events:Unsubscribe( self.LocalPlayerInputEvent )
		self.LocalPlayerInputEvent = nil
	end
end

function BetterChat:ChatPosChanger()
	if not self.controlstipSh then
		self.controlstipSh = Label.Create()
		self.controlstipSh:SetText( self.tiptext )
		self.controlstipSh:SetTextSize( 20 )
		self.controlstipSh:SetTextColor( Color.Black )
		if LocalPlayer:GetValue( "SystemFonts" ) then
			self.controlstipSh:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		self.controlstipSh:SizeToContents()
		self.controlstipSh:SetPosition( Vector2( (Render.Size.x / 2) - (Render:GetTextSize( self.tiptext, 20 ).x / 2), 60 ) )

		self.controlstip = Label.Create()
		self.controlstip:SetText( self.tiptext )
		self.controlstip:SetTextSize( 20 )
		if LocalPlayer:GetValue( "SystemFonts" ) then
			self.controlstip:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		self.controlstip:SizeToContents()
		self.controlstip:SetPosition( self.controlstipSh:GetPosition() - Vector2.One )
	end

	self.window:SetVisible( false )

	if not self.MouseUpEvent then
		self.MouseUpEvent = Events:Subscribe( "MouseUp", self, self.MouseUp )
		self.MouseMoveEvent = Events:Subscribe( "MouseMove", self, self.MouseMove )
	end
end

function BetterChat:MouseMove( args )
	Chat:SetPosition( Mouse:GetPosition() )
end

function BetterChat:MouseUp( args )
	if args.button == 1 then
		if self.controlstipSh then
			self.controlstipSh:Remove()
			self.controlstipSh = nil
			self.controlstip:Remove()
			self.controlstip = nil
		end

		self.customchatpos = Mouse:GetPosition()
		Network:Send( "SaveChatPos", { chatpos = self.customchatpos } )
		self.window:SetVisible( true )

		if not self.ResolutionChangeEvent then
			self.ResolutionChangeEvent = Events:Subscribe( "ResolutionChange", self, self.ResolutionChange )
		end

		if self.MouseUpEvent then
			Events:Unsubscribe( self.MouseUpEvent )
			self.MouseUpEvent = nil
			Events:Unsubscribe( self.MouseMoveEvent )
			self.MouseMoveEvent = nil
		end
	end
end

function BetterChat:ResolutionChange( args )
	Chat:SetPosition( self.customchatpos )
end

function BetterChat:ChatPosReset( args )
	Chat:ResetPosition()
	Network:Send( "ResetChatPos" )
	if self.ResolutionChangeEvent then
		Events:Unsubscribe( self.ResolutionChangeEvent )
		self.ResolutionChangeEvent = nil
	end
end

function BetterChat:KeyUp( args )
	if string.char(args.key) == "H" then
	if self.toggle <= 1 then
		self.toggle = self.toggle + 1
	else
		self.toggle = 0
	end
		if self.toggle == 1 then
			self.text = self.tLocal
			Chat:Print( self.chModeMsg .. self.text .. "!", Color( 0, 255, 100 ) )
		end
		if self.toggle == 0 then
			self.text = self.tGlobal
			Chat:Print( self.chModeMsg .. self.text .. "!", Color( 0, 255, 100 ) )
		end
		if self.toggle == 2 then
			self.text = self.tPrefix
			Chat:Print( self.chModeMsg .. self.text .. "!", Color( 0, 255, 100 ) )
		end
		Network:Send( "toggle", self.toggle )
	end
end

function BetterChat:Render()
	if Chat:GetActive() then
		if LocalPlayer:GetValue( "SystemFonts" ) then
			Render:SetFont( AssetLocation.SystemFont, "Impact" )
		end
		Render:DrawText( Chat:GetPosition() - Vector2( -1, Render:GetTextHeight( self.name ) * 14.6 ), self.name .. self.text .. self.nameTw, Color( 25, 25, 25, 150 ), 13 +1 )
		Render:DrawText( Chat:GetPosition() - Vector2( 0, Render:GetTextHeight( self.name ) * 14.6 + 1 ), self.name .. self.text .. self.nameTw, Color( 200, 200, 200 ), 13 +1 )
	end
end

betterchat = BetterChat()