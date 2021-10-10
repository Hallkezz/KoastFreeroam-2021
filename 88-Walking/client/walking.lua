class 'Walking'

function Walking:__init()
    if not LocalPlayer:InVehicle() then
        self.InputPollEvent = Events:Subscribe( "InputPoll", self, self.InputPoll )
    end

    Events:Subscribe( "LocalPlayerEnterVehicle", self, self.LocalPlayerEnterVehicle )
	Events:Subscribe( "LocalPlayerExitVehicle", self, self.LocalPlayerExitVehicle )
end

function Walking:LocalPlayerEnterVehicle()
	if self.InputPollEvent then
		Events:Unsubscribe( self.InputPollEvent )
		self.InputPollEvent = nil
	end
end

function Walking:LocalPlayerExitVehicle()
	if not self.InputPollEvent then
		self.InputPollEvent = Events:Subscribe( "InputPoll", self, self.InputPoll )
	end
end

function Walking:InputPoll()
    if Input:GetValue( Action.StuntJump ) == 0 then
        Input:SetValue(Action.Walk, 0)
    else
        Input:SetValue(Action.Walk, 1)
    end
end

walking = Walking()