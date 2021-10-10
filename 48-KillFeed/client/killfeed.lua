class 'Killfeed'

function Killfeed:__init()
	self.list = {}
	self.removal_time = 18

	self:CreateKillStrings()

	Network:Subscribe( "PlayerDeath", self, self.PlayerDeath )

	Events:Subscribe( "Render", self, self.Render )
end

function Killfeed:PlayerDeath( args )
	if not IsValid( args.player ) then return end
	local reason = args.reason

	if args.killer then
		if not self.killer_msg[reason] then
			reason = DamageEntity.None
		end
	else
		if not self.no_killer_msg[reason] then
			reason = DamageEntity.None
		end
	end

	if args.killer then
		args.message = string.format( self.killer_msg[reason][args.id], args.player:GetName(), args.killer:GetName() )

		args.killer_name   = args.killer:GetName()
		args.killer_colour = args.killer:GetColor()
	else
		args.message = string.format( self.no_killer_msg[reason][args.id], args.player:GetName() )
	end

	args.player_name   = args.player:GetName()
	args.player_colour = args.player:GetColor()

	args.time = os.clock()

	table.insert( self.list, args )
end

function Killfeed:CreateKillStrings()
	self.no_killer_msg = {
		[DamageEntity.None] = { 
			"%s умер от инфаркта",
			"%s отдал душу дьяволу",
			"%s скопытился"
		},

		[DamageEntity.Physics] = { 
			"%s помер",
			"%s ушатался",
			"%s чет сдох"
		},

		[DamageEntity.Bullet] = { 
			"%s застрелен",
			"%s был смертельно ранен",
			"%s поймал маслину"
		},

		[DamageEntity.Explosion] = { 
			"%s взорвался",
			"%s подорвался",
			"%s сделал бум!"
		},

		[DamageEntity.Vehicle] = {
			"%s забыл надеть ремень безопасности",
			"%s попал под машину",
			"%s сделал селфи за рулем"
		}
	}

	self.killer_msg = {
		[DamageEntity.None] = { 
			"%s каким-то образом убит %s",
			"%s тронут магией %s",
			"%s поздоровался с %s"
		},

		[DamageEntity.Physics] = { 
			"%s был убит %s",
			"%s получил леща %s",
			"%s встретился с %s"
		},

		[DamageEntity.Bullet] = { 
			"%s был убит %s",
			"%s был измельчен %s",
			"%s поймал маслину от %s"
		},

		[DamageEntity.Explosion] = { 
			"%s подорван %s",
			"%s оснащен взрывами %s",
			"%s взорван %s"
		},

		[DamageEntity.Vehicle] = {
			"%s поцеловал бампер %s",
			"%s попал в ярость дороги %s",
			"%s сбит %s"
		}
	}
end

function Killfeed:CalculateAlpha( time )
	local difftime = os.clock() - time
	local removal_time_gap = self.removal_time - 1

	if difftime < removal_time_gap then
		return 255
	elseif difftime >= removal_time_gap and difftime < self.removal_time then
		local interval = difftime - removal_time_gap
		return 255 * (1 - interval)
	else
		return 1
	end
end

function Killfeed:Render( args )
	if Game:GetState() ~= GUIState.Game then return end
	if not LocalPlayer:GetValue( "KillFeedVisible" ) then return end

	local center_hint = Vector2( Render.Width - 25, Render.Height / 4.8 )
	local height_offset = 0

	for i,v in ipairs( self.list ) do
		if os.clock() - v.time < self.removal_time then
			local text_width = Render:GetTextWidth( v.message )
			local text_height = Render:GetTextHeight( v.message )

			local pos = center_hint + Vector2( -text_width, height_offset )
			local alpha = self:CalculateAlpha( v.time )

			local shadow_colour = Color( 20, 20, 20, alpha * 0.5 )

			Render:DrawText( pos + Vector2.One, v.message, shadow_colour )
			Render:DrawText( pos, v.message, Color( 255, 255, 255, alpha ) )

			local player_colour = v.player_colour
			player_colour.a = alpha

			local img_width = text_height

			Render:DrawText( pos, v.player_name, player_colour )

			if v.killer_name ~= nil then
				local killer_colour = v.killer_colour
				killer_colour.a = alpha
				local name_text = v.killer_name
				local name_width = Render:GetTextWidth( name_text )

				Render:DrawText( center_hint + Vector2( -name_width, height_offset ), v.killer_name, killer_colour )
			end

			height_offset = height_offset + text_height + 4
		else
			table.remove( self.list, i )
		end
	end
end

killfeed = Killfeed()