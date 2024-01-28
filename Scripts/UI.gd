extends Control

@export var rect : TextureRect

enum PlayerState {
	HAPPY,
	NEUTRAL,
	DREAD,
	DROWN,
	DEAD
}

@export var faces : Array[Texture2D]


func UpdateFace(state):
	var face = faces[0]
	match state:
		PlayerState.HAPPY:
			face = faces[0]
			pass
		PlayerState.NEUTRAL:
			face = faces[1]
			pass
		PlayerState.DREAD:
			face = faces[2]
			pass
		PlayerState.DEAD:
			face = faces[3]
			pass
	
	rect.texture = face
