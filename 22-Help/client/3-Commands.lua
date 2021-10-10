class 'HCommands'

function HCommands:__init()
	Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
	Events:Subscribe( "EngHelp", self, self.EngHelp )
end

function HCommands:EngHelp()
	Events:Fire( "HelpRemoveItem",
		{
			name = "Команды"
		} )
	Events:Fire( "HelpAddItem",
		{
			name = "Commands",
			text =
				"* All commands must be entered in the game chat (T).\n \n" ..
				"> Basic:\n" ..
				"    /pos                      Get Coordinates.\n" ..
				"    /stats                    Show account information on the server.\n" ..
				"    /bind                     Key binding.\n" ..
				"    /gethome             Get Home Coordinates.\n" ..
				"    /repair                   Repair vehicle.\n" ..
				"    /mass <value>      Change vehicle mass.\n \n" ..
				"> Chat:\n" ..
				"    /me <text>        Action.\n" ..
				"    /try <text>         Solving disputes.\n" ..
				"    /cd <time>        Countdown.\n" ..
				"    /f <text>        Clan chat.\n" ..
				"    /pm <player> <message>      Send a private message.\n \n" ..
				"> Mini-games:\n" ..
				"    /tron             Join/Leave on Tron.\n" ..
				"    /khill              Join/Leave on King Of The Hill.\n" ..
				"    /derby            Join/Leave on Derby.\n" ..
				"    /race              Open Racing Menu.\n" ..
				"    /pong <difficulty> Playing Pong.\n" ..
				"       *difficulties: Noob, Easy, Medium, Hard, Extreme"
		} )
end

function HCommands:ModulesLoad()
	Events:Fire( "HelpAddItem",
		{
			name = "Команды",
			text =
				"* Все команды нужно вводить в игровой чат (T).\n \n" ..
				"> Часто используемые:\n" ..
				"    /pos                      Узнать координаты.\n" ..
				"    /stats                    Показать данные об аккаунте на сервере.\n" ..
				"    /bind                    Привязка клавиш.\n" ..
				"    /gethome             Получить координаты дома.\n" ..
				"    /repair                  Починить транспорт.\n" ..
				"    /mass <число>   Изменить массу транспорта.\n \n" ..
				"> Чат:\n" ..
				"    /me <текст>        Действие.\n" ..
				"    /try <текст>         Решение спорных ситуаций.\n" ..
				"    /cd <время>        Обратный отсчёт.\n" ..
				"    /f <текст>            Чат клана.\n" ..
				"    /pm <игрок> <сообщение>      Отправить личное сообщение.\n \n" ..
				"> Развлечения:\n" ..
				"    /tron              Войти/выйти в лобби на Трон.\n" ..
				"    /khill              Войти/выйти в лобби на Царь Горы.\n" ..
				"    /derby            Войти/выйти в лобби на Дерби.\n" ..
				"    /race              Открыть меню гонок.\n" ..
				"    /pong <сложность> Играть в понг.\n" ..
				"       *сложности: Noob, Easy, Medium, Hard, Extreme"
		} )
end

hcommands = HCommands()