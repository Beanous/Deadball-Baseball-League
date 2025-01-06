extends Node2D

<<<<<<< Updated upstream
func _on_button_pressed_():
	var num =  randi_range(1,20)
	$Label.text = str(num)
=======
@export var player_scene: PackedScene

enum hitTypes {Normal = 0,Crit = 1,Worse = -1}
enum errTypes {Swing = 1, Hit = 2}

var scoreTracker : int = 0
var outTracker : int = 0
var inningTracker : int = 1
var teamArray : Array[String]
var atBatTeam : String 

func _ready():
	teamArray = ["Infernos","Spartans"]
	$GridContainer/HomeTeamName.text = teamArray[0]
	$GridContainer/AwayTeamName.text = teamArray[1]
	atBatTeam = teamArray[0]
	UpdateScoreBoard()


func _process(delta: float) -> void:
	UpdateScoreBoard()
	if (outTracker == 3):
		print("Next Inning")
		outTracker=0
		var curTeam = teamArray.find(atBatTeam)
		if (curTeam == 0):
			atBatTeam = teamArray[1]
		elif (curTeam == 1):
			inningTracker += 1
			atBatTeam = teamArray[0]
		

func _on_button_pressed():
	var swing =  randi_range(1,100)
	swingTable(swing)

#Function that runs swing table result
func swingTable(swingNum :int):
	var batter = { "BatTarget" : 26, "OnBaseTarget" : 33}
	print("Swing Num: ",swingNum)
	if(swingNum == 1):
		print("Oddity")
	elif(swingNum <=5):
		var hitNum =  randi_range(1,20)
		print("Critical ",hitNum)
		hitTable(hitNum,hitTypes.Crit)
	elif(swingNum >= 6 && swingNum <= batter["BatTarget"]):
		var hitNum =  randi_range(1,20)
		print("Ordinary Hit ",hitNum)
		hitTable(hitNum,hitTypes.Normal)
	elif(swingNum >= batter["BatTarget"] && swingNum <= batter["OnBaseTarget"]):
		print("Walk")
		$Runner.moveBases(0,1)
	elif(swingNum >= batter["OnBaseTarget"]+1 && swingNum <= batter["OnBaseTarget"]+5):
		var errNum = randi_range(1,12)
		print("Possible Error ",errNum)
		errorTable(errNum, errTypes.Swing)
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

func errorTable(errNum : int, errType : int):
	if errType == errTypes.Swing:
		if (errNum <3):
			print("Runner Extra Base")
			hitTable(1,hitTypes.Normal)
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

func hitTable(hitNum : int, hitMod : int):
	if (hitNum <= 14):
		$Runner.moveBases(0,1+hitMod)
	if (hitNum >= 15 && hitNum <=18):
		$Runner.moveBases(0,2+hitMod)
	if (hitNum > 18):
		$Runner.moveBases(0,4+hitMod)

func UpdateScoreBoard():
	$GridContainer/OutCounter.text = "Outs: "+str(outTracker)
	$GridContainer/ScoreCounter.text = "Score: "+str(scoreTracker)
	$GridContainer/InningCounter.text = "Inning: "+str(inningTracker)
	$GridContainer/AtBatTeamName.text = atBatTeam+" at bat"

func spawnPlayer():
	var player = player_scene.instantiate()
	var playerSpwan = Vector2(576,537)
	
	player.ready
	add_child(player)
>>>>>>> Stashed changes
