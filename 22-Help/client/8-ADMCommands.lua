class 'HCommands'

function HCommands:__init()
	Events:Subscribe( "LoadAdminsTab", self, self.LoadAdminsTab )
	Events:Subscribe( "UnloadAdminsTab", self, self.UnloadAdminsTab )
end

function HCommands:LoadAdminsTab()
	if LocalPlayer:GetValue( "Tag" ) == "Creator" or LocalPlayer:GetValue( "Tag" ) == "GlAdmin" or LocalPlayer:GetValue( "Tag" ) == "Admin" then
		Events:Fire( "HelpAddItem",
			{
				name = "Админское :3",
				text =
					"> Админам:\n" ..
					"    /petyx                 Дать петуча.\n" ..
					"    /unpetyx            Убрать петуча.\n" ..
					"    /priv                    Поприветствовать игрока в общий чат (анонимно).\n" ..
					"    /poka                  Попрощаться с игроком в общий чат (анонимно).\n" ..
					"    /warn                  Дать проста варн.\n" ..
					"    /warn(1-3)          Дать варны (число берется от веденной цифры).\n" ..
					"    /getwarns          Узнать сколько варнов у игрока.\n" ..
					"    /getop                Узнать сколько бабла.\n" ..
					"    /boom                Взорвать тс.\n" ..
					"    /kick                   Кикнуть игрока.\n" ..
					"    /skick                 Беспалевно кикнуть игрока.\n" ..
					"    /boton                Включить бота-чистильщика.\n" ..
					"    /botoff                Выключить бота-чистильщика.\n" ..
					"    /kill                     Ушатать игрока.\n" ..
					"    /sky                    Отправить игрока в небо.\n" ..
					"    /hidetag             Скрыть/показать тэг над головой.\n" ..
					"    /rnb                    Включить переливание цветов для транспорта.\n" ..
					"    /ptphere             Телепортировать к себе.\n \n" ..
					"> Гл. Админам:\n" ..
					"    /ban                    Кинуть игрока в ЧС (разбан только владельцем).\n" ..
					"    /remveh              Удалить весь ТС с сервера до его рестарта (В САМЫХ КРАЙНИХ СЛУЧАЯХ).\n" ..
					"    /clearchat           Очистить чат (не очищает историю).\n" ..
					"    /notice                Сообщение на экраны игроков.\n" ..
					"    /addmoney        Дать бабла игроку.\n" ..
					"    /setgm                Изменить режим игроку (только визуально).\n" ..
					"    /setlang              Изменить язык игроку (только визуально)."
			} )
	end
end

function HCommands:UnloadAdminsTab()
	if LocalPlayer:GetValue( "Tag" ) == "Creator" or LocalPlayer:GetValue( "Tag" ) == "GlAdmin" or LocalPlayer:GetValue( "Tag" ) == "Admin" then
		Events:Fire( "HelpRemoveItem",
			{
				name = "Админское :3"
			} )
	end
end

hcommands = HCommands()