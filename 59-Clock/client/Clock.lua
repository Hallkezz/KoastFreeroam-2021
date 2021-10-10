class 'DateTime'

function DateTime:__init()
	self.CLtime = os.date( "%X" )
	self.CLdate = os.date("%d/%m/%Y")

	Events:Subscribe( "Render", self, self.Render )
end

function DateTime:Render()
	if Game:GetState() ~= GUIState.Game or Game:GetSetting(4) <= 1 then return end
	if not LocalPlayer:GetValue( "ClockVisible" ) then return end
	if LocalPlayer:GetValue( "ClockPendosFormat" ) then
		self.CLtime = os.date("%I:%M:%S %p")
	else
		self.CLtime = os.date( "%X" )
	end

	self.CLdate = os.date("%d/%m/%Y")

	local position = Vector2( 20, Render.Height * 0.31 )
	local text = tostring( self.CLtime )
	local pos_1 = Vector2( (20)/1, (Render.Height/3) + 5)
	local text1 = tostring( self.CLdate )

	local text_width = Render:GetTextWidth( text )
	Render:SetFont( AssetLocation.Disk, "Archivo.ttf" )
	Render:DrawText( position + Vector2.One, text, Color( 25, 25, 25, Game:GetSetting(4) * 2.25 ), 24 )
	Render:DrawText( position, text, Color( 255, 255, 255, Game:GetSetting(4) * 2.25 ), 24 )

	local height = Render:GetTextHeight("A") * 1.5
	position.y = position.y + height
	Render:DrawText( position + Vector2.One, text1, Color( 25, 25, 25, Game:GetSetting(4) * 2.25 ), 16 )
	Render:DrawText( position, text1, Color( 255, 165, 0, Game:GetSetting(4) * 2.25 ), 16 )		
end

datetime = DateTime()