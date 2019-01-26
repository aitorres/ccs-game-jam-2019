extends RichTextLabel

# class member variables go here, for example:
# var a = 2
export(float, 0, 20, 0.01) var lineWaitTime = 2
export(float, 0, 1, 0.00001) var charWaitTime = 0.001
export(String, MULTILINE) var longText
export(bool) var startOnReady = false
export(bool) var startOnFirstLine = false

var arrText = []
var currText = ""
var curPos = 0
var targetChar = 0

var lineAccTime = 0
var charAccTime = 0
var charComplete = false
var textSize = 0

func _ready():
	if startOnReady:
		config_text()
	

func config_text():
	if longText != null:
		arrText = longText.split("\n")
		textSize = arrText.size()
	else:
		longText = []
		textSize = 0
		return
	
	if startOnFirstLine:
		currText = arrText[0]
		curPos = 1
		charComplete = false
	else:
		currText = ""
		curPos = 0
		charComplete = true
	
	visible_characters = 0
	parse_bbcode(currText)
	


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.

	if curPos < textSize || charAccTime > 0:
		if charComplete:
			if lineAccTime < lineWaitTime:
				lineAccTime += delta
			else:
				print(lineAccTime)
				var currLine = arrText[curPos].replace("\\n", "\n")
				currLine = currLine.replace("\\t", "\t")
				if currLine.find("\\c") != -1:
					currText = ""
					currLine = currLine.replace("\\c", "")
					print("Clear")
				
				currLine += "\n"
				currText += currLine 
				targetChar = currLine.length()
				parse_bbcode(currText)
				curPos += 1
				visible_characters = 0
				lineAccTime = 0
				charAccTime = 0
				charComplete = false
				print("Line Complete")
		else:
			if charAccTime < charWaitTime:
				charAccTime += delta
			else:
				charAccTime = 0
				visible_characters += 1
				print(targetChar)
				print(visible_characters)
				targetChar -= 1
				if targetChar <= 0:
					charComplete = true
					charAccTime = 0
					print("Char Complete")


		

