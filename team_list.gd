extends ItemList

enum rosterHeader {Name=0,Age=1,Position=2,Hand=3,BatTarget=4,OnBaseTarget=4,Pitcher=5,PitchDie=6,Traits=7,Team=9}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rosterData = preload("res://DBL/DBL_Roster_File.csv").records
	var TeamList: Array
	var arrayLen = rosterData.size()
	for x in arrayLen:
		##print(rosterData[x][rosterHeader.Team])
		if x != 0 :
			TeamList.append(rosterData[x][rosterHeader.Team])
		x += 1
	var fTeamList = unique_array(TeamList)
	for x in fTeamList:
		print(x)
		self.add_item(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func unique_array(arr: Array) -> Array:
	var dict := {}
	for a in arr:
		dict[a] = 1
	return dict.keys()
