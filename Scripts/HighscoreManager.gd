extends Node

var highScore: int = 0

func SetHighscore(score :int):
	if highScore < score:
		highScore = score

func GetHighscore():
	return highScore
	
func GetHighScoreAsString():
	return str(highScore)
