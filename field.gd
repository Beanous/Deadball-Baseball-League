extends Node

@export var player_scene: PackedScene

enum hitTypes {Normal = 0,Crit = 1,Worse = -1}
enum errTypes {Swing = 1, Hit = 2}
enum rosterDataType {Name=0,Age=1,Position=2,Hand=3,BatTarget=4,OnBaseTarget=5,Pitcher=6,PitchDie=7,Traits=8,Team=9,Position2=10,HRs=11,BatAvg=12,Ks=13,BBs=14,IPs=15}


var scoreTracker : int = 0
var outTracker : int = 0
var inningTracker : int = 1
var teamArray : Array[String]
var atBatTeam : String
var atBatTeamNum : int = 0

#Arrays to hold both teams and a combined array 
var homeTeamPlayerArray : Array[Node2D]
var awayTeamPlayerArray : Array[Node2D]
var bothTeamsPlayerArray : Array[Array]

#Variable for tracking currently at bat player
var curBatNumArray = [0,0]

var gameStarted : bool = false

var rosterData

func _ready():
	rosterData = preload("res://DBL/DBL_Roster_File.csv").records
	
	$TeamSelect.visible = true
	
	$Scoreboard.visible = false

	$Button.visible = false
	$StartGameButton.visible = true
	$StartGameButton.disabled = true
	
	readPlayerData()
	
	#createScoreBoard()
	
	pass


func _process(delta: float) -> void:
	if gameStarted:
		RefreshScoreboard()
		if (outTracker == 3):
			print("Next Inning")
			outTracker=0
			if (atBatTeamNum == 0):
				atBatTeamNum = 1
				atBatTeam = teamArray[atBatTeamNum]
			else:
				inningTracker += 1
				atBatTeamNum = 0
				atBatTeam = teamArray[atBatTeamNum]
	
	##Only allows start game to be selected when both teams are selected
	if ($TeamSelect/HomeTeamSelect.is_anything_selected() == true) and ($TeamSelect/AwayTeamSelect.is_anything_selected() == true):
			$StartGameButton.disabled = false
	else: 
			$StartGameButton.disabled = true

func _on_button_pressed():
	var swing =  randi_range(1,100)
	var curTeam = curBatNumArray[atBatTeamNum]
	swingTable(swing, bothTeamsPlayerArray[atBatTeamNum][curTeam])
	UpdateBatterBoard()
	if (curBatNumArray[atBatTeamNum] +1 >= bothTeamsPlayerArray[atBatTeamNum].size()):
		curBatNumArray[atBatTeamNum] = 0
	else :
		curBatNumArray[atBatTeamNum] += 1
		
	

#Function that runs swing table result
func swingTable(swingNum :int, atBatPlayer : Node2D):
	print("Current Batter: ",bothTeamsPlayerArray[atBatTeamNum][curBatNumArray[atBatTeamNum]].playerName)
	var batter = { "BatTarget" : 26, "OnBaseTarget" : 33}
	print("Swing Num: ",swingNum)
	if(swingNum == 1):
		print("Oddity")
	elif(swingNum <=5):
		var hitNum =  randi_range(1,20)
		print("Critical ",hitNum)
		hitTable(hitNum,hitTypes.Crit, atBatPlayer)
	elif(swingNum >= 6 && swingNum <= batter["BatTarget"]):
		var hitNum =  randi_range(1,20)
		print("Ordinary Hit ",hitNum)
		hitTable(hitNum,hitTypes.Normal, atBatPlayer)
	elif(swingNum >= batter["BatTarget"] && swingNum <= batter["OnBaseTarget"]):
		print("Walk")
		atBatPlayer.moveBases(0,1)
	elif(swingNum >= batter["OnBaseTarget"]+1 && swingNum <= batter["OnBaseTarget"]+5):
		var errNum = randi_range(1,12)
		print("Possible Error ",errNum)
		errorTable(errNum, errTypes.Swing, atBatPlayer)
	elif(batter["OnBaseTarget"]+5<50 && swingNum>= batter["OnBaseTarget"]+5 && swingNum<50):
		print("Productive Out")
		outTracker += 1
		outTable(swingNum)
	elif(swingNum>= 50 && swingNum<70):
		print("Productive Out 2")
		outTracker += 1
		outTable(swingNum)
	elif(swingNum >= 70 && swingNum <99):
		print("Out")
		outTracker += 1
		outTable(swingNum)
	elif(swingNum == 99):
		print("Injury")	
	elif(swingNum >= 100):
		print("Out")
		outTracker += 1
	else:
		print("Script Error")


func outTable(outNum:int):
	var outResult = (outNum) % 10
	print(outResult)
	if (outResult <= 2):
		print("Strikeout!")
	if (outResult >=3 && outResult <=6):
		print("Groundball")
	if (outResult >=7):
		print("Flyball")

func errorTable(errNum : int, errType : int, atBatPlayer):
	if errType == errTypes.Swing:
		if (errNum <3):
			print("Runner Extra Base")
			hitTable(1,hitTypes.Normal, atBatPlayer)
		else:
			outTracker += 1
			print("Out - No Error")
	elif (errType == errTypes.Hit):
		if (errNum <3):
			print("Runner Extra Base")
		elif (errNum >=3 && errNum <= 9):
			print("No Change")
		elif (errNum >=10 && errNum <= 11):
			print("Double into Singles")
		elif (errNum == 12):
			print("Hit into Out")

func hitTable(hitNum : int, hitMod : int, atBatPlayer):
	if (hitNum <= 14):
		atBatPlayer.moveBases(0,1+hitMod)
	if (hitNum >= 15 && hitNum <=18):
		atBatPlayer.moveBases(0,2+hitMod)
	if (hitNum > 18):
		atBatPlayer.moveBases(0,4+hitMod)
	
func RefreshScoreboard():
	$Scoreboard/MainBoxInfo/HomeTeamScore/HomeTeamName.text = teamArray[0]
	$Scoreboard/MainBoxInfo/AwayTeamScore/AwayTeamName.text = teamArray[1]
	$Scoreboard/MainBoxInfo/HomeTeamLogo.texture = load("res://DBL/Team Logos/No Background/"+teamArray[0]+".PNG")
	$Scoreboard/MainBoxInfo/AwayTeamLogo.texture = load("res://DBL/Team Logos/No Background/"+teamArray[1]+".PNG")
	$Scoreboard/MainBoxInfo/MiddleBox/InningValue.text = str(inningTracker)
	$Scoreboard/MainBoxInfo/MiddleBox/OutsValue.text = str(outTracker)
	if atBatTeamNum == 0:
		$Scoreboard/BottomBoxInfo/BatterInfo.text = homeTeamPlayerArray[curBatNumArray[0]].playerName+" at bat"
	else :
		$Scoreboard/BottomBoxInfo/BatterInfo.text = awayTeamPlayerArray[curBatNumArray[1]].playerName+" at bat"


func UpdateBatterBoard():
	$AtBatList.clear()
	
	if atBatTeamNum == 0:
		var teamSize = len(homeTeamPlayerArray)
		var curBatStart = curBatNumArray[0]
		for x in range(curBatStart,teamSize,1):
			$AtBatList.add_item(homeTeamPlayerArray[x].playerName)
	else:
		var teamSize = len(awayTeamPlayerArray)
		var curBatStart = curBatNumArray[1]
		for x in range(curBatStart,teamSize,1):
			$AtBatList.add_item(awayTeamPlayerArray[x].playerName)

func generatePlayers():
	var instance = preload("res://player.tscn")
	for x in rosterData:
		if x[rosterDataType.Team] == teamArray[0]:
			var temp = instance.instantiate()
			add_child(temp)
			temp.setPlayerStats(x)
			temp.position = $HomeTeamSpawn.position
			homeTeamPlayerArray.append(temp)
		if x[rosterDataType.Team] == teamArray[1]:
			var temp = instance.instantiate()
			add_child(temp)
			temp.setPlayerStats(x)
			temp.position = $AwayTeamSpawn.position
			awayTeamPlayerArray.append(temp)
	bothTeamsPlayerArray.append(homeTeamPlayerArray)
	bothTeamsPlayerArray.append(awayTeamPlayerArray)

func readPlayerData():
	var data = preload("res://DBL/DBL_Roster_File.csv")


func _on_start_game_button_pressed() -> void:
	var homeTeamInt = $TeamSelect/HomeTeamSelect.get_selected_items()[0]
	var awayTeamInt = $TeamSelect/AwayTeamSelect.get_selected_items()[0]
	if len(teamArray)>0:
		teamArray.clear()
	teamArray.append($TeamSelect/HomeTeamSelect.get_item_text(homeTeamInt))
	teamArray.append($TeamSelect/AwayTeamSelect.get_item_text(awayTeamInt))
	atBatTeam = teamArray[0]
	
	generatePlayers()
	
	$Scoreboard.visible = true
	
	gameStarted = true
	$TeamSelect.visible = false
	
	$Button.visible = true
	$StartGameButton.visible = false
