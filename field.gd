extends Node

@export var player_scene: PackedScene

enum hitTypes {Normal = 0,Crit = 1,Worse = -1}
enum errTypes {Swing = 1, Hit = 2}

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

func _ready():
	teamArray = ["Infernos","Spartans"]
	$GridContainer/HomeTeamName.text = teamArray[0]
	$GridContainer/AwayTeamName.text = teamArray[1]
	atBatTeam = teamArray[0]
	UpdateScoreBoard()
	
	readPlayerData()
	
	#createScoreBoard()
	
	spawnPlayers()
	


func _process(delta: float) -> void:
	UpdateScoreBoard()
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

		

func _on_button_pressed():
	var swing =  randi_range(1,100)
	var curTeam = curBatNumArray[atBatTeamNum]
	swingTable(swing, bothTeamsPlayerArray[atBatTeamNum][curTeam])
	if (curBatNumArray[atBatTeamNum] +1 >= bothTeamsPlayerArray[atBatTeamNum].size()):
		curBatNumArray[atBatTeamNum] = 0
	else :
		curBatNumArray[atBatTeamNum] += 1

#Function that runs swing table result
func swingTable(swingNum :int, atBatPlayer : Node2D):
	print("Current Batter: ",bothTeamsPlayerArray[atBatTeamNum][curBatNumArray[atBatTeamNum]])
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

func UpdateScoreBoard():
	$GridContainer/OutCounter.text = "Outs: "+str(outTracker)
	$GridContainer/ScoreCounter.text = "Score: "+str(scoreTracker)
	$GridContainer/InningCounter.text = "Inning: "+str(inningTracker)
	$GridContainer/AtBatTeamName.text = atBatTeam+" at bat"

func spawnPlayers():
	var instance = preload("res://player.tscn")
	for a in range(0,9,1):
		var temp = instance.instantiate()
		add_child(temp)
		temp.position = $HomeTeamSpawn.position
		homeTeamPlayerArray.append(temp)
	for b in range(0,9,1):
		var temp = instance.instantiate()
		add_child(temp)
		temp.position = $AwayTeamSpawn.position
		awayTeamPlayerArray.append(temp)
	bothTeamsPlayerArray.append(homeTeamPlayerArray)
	bothTeamsPlayerArray.append(awayTeamPlayerArray)


func createScoreBoard():
	var instance = preload("res://Scoreboard.tscn")
	var temp = instance.instantiate()
	add_child(temp)
	temp.scale = Vector2(0.5,0.5)
	var sbSize = temp.get_node("ScoreboardSprite").get_rect().size
	print(sbSize)
	var screenSize = get_viewport().get_visible_rect().size
	#temp.position = Vector2(screenSize.x - sbSize.x,screenSize.y - sbSize.y)
	temp.position = Vector2(700, 400)

func readPlayerData():
	var data = preload("res://DBL/DBL_Roster_File.csv")


func _on_start_game_button_pressed() -> void:
	var homeTeamInt = $HomeTeamSelect.get_selected_items()[0]
	var awayTeamInt = $AwayTeamSelect.get_selected_items()[0]
	teamArray.clear()
	teamArray.append($HomeTeamSelect.get_item_text(homeTeamInt))
	teamArray.append($AwayTeamSelect.get_item_text(awayTeamInt))
	$GridContainer/HomeTeamName.text = teamArray[0]
	$GridContainer/AwayTeamName.text = teamArray[1]
	atBatTeam = teamArray[0]
	UpdateScoreBoard()
