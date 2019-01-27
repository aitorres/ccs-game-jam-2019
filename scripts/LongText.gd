extends RichTextLabel

# class member variables go here, for example:
# var a = 2
export(float, 0, 20, 0.01) var lineWaitTime = 2
export(float, 0, 1, 0.00001) var charWaitTime = 0.001
export(float, 0, 1, 0.0000001) var vibrateWaitTime = 0.001
export(String, MULTILINE) var longText
export(bool) var start = false
export(bool) var startOnFirstLine = false
export(bool) var vibrate = false
export(bool) var done = false
export(float, 0, 20, 0.01) var vibrateMax = 20

var triggered = -1

var arrText = []
var currText = ""
var curPos = 0
var targetChar = 0

var lineAccTime = 0
var charAccTime = 0
var vibrateAccTime = 0
var charComplete = false
var textSize = 0
var textComplete = false
var linePos = 0
var currLine = ""

var imgRegex = RegEx.new()
var bbcodeRegex = RegEx.new()
var charWaitRegex = RegEx.new()
var lineWaitRegex = RegEx.new()
var vibrateWaitRegex = RegEx.new()

var textCenter =  Vector2(0,0)

var background = null

func reset_config():
	done = false
	charComplete = false
	textComplete = false

func reset_text(state):
	start = state
	done = false
	if background == null:
		background = get_parent()
		textCenter = rect_position
	config_text()
	
	
	if start:
		background.show()
		show()
	else:
		background.hide()
		hide()

func _ready():
	reset_text(start)

func config_text():
	rect_position = textCenter
	if longText != null:
		arrText = longText.split("\n")
		textSize = arrText.size()
	else:
		longText = []
		textSize = 0
		textComplete = true
		charComplete = true
		return

	if startOnFirstLine:
		currText = arrText[0]
		curPos = 1
		charComplete = false
	else:
		currText = ""
		curPos = 0
		linePos = 0
		charComplete = true

	visible_characters = 0
	parse_bbcode(currText)

	imgRegex.compile("\\[img\\].*\\[/img\\]")
	bbcodeRegex.compile("\\[[^\\]]*\\]")
	charWaitRegex.compile("\\[char=(?<val>[-+]?[0-9]*\\.?[0-9]+)\\]")
	lineWaitRegex.compile("\\[line=(?<val>[-+]?[0-9]*\\.?[0-9]+)\\]")
	vibrateWaitRegex.compile("\\[vibrate=(?<val>[-+]?[0-9]*\\.?[0-9]+)(,(?<val2>[-+]?[0-9]*\\.?[0-9]+))?\\]")
	


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if start:
		animateText(delta)


func animateText(delta):
	if !textComplete || (textComplete && !charComplete):
		if charComplete:
			if lineAccTime < lineWaitTime:
				lineAccTime += delta
			else:
				print(lineAccTime)

				currLine = arrText[curPos].replace("\\n", "\n")
				currLine = currLine.replace("\\t", "\t")

				if currLine.find("\\c") != -1:
					currText = ""
					currLine = currLine.replace("\\c", "")
					print("Clear")

				vibrate = false
				rect_position = textCenter
				
				var regexRes = charWaitRegex.search(currLine)

				if regexRes:
					currLine = charWaitRegex.sub(currLine, "")
					charAccTime =  float(regexRes.get_string("val"))
					print("charWait=" + regexRes.get_string("val"))

				regexRes = lineWaitRegex.search(currLine)

				if regexRes:
					currLine = lineWaitRegex.sub(currLine, "")
					lineWaitTime =  float(regexRes.get_string("val"))
					print("lineWait=" + regexRes.get_string("val"))

				regexRes = vibrateWaitRegex.search(currLine)

				if regexRes:
					currLine = vibrateWaitRegex.sub(currLine, "")
					vibrateWaitTime = float(regexRes.get_string("val"))
					vibrate = true
					var val2 = regexRes.get_string("val2")
					if val2:
						vibrateMax = float(val2)
						print("vibrate=" + regexRes.get_string("val") + ", " + val2)
					else:
						print("vibrate=" + regexRes.get_string("val"))

				if currLine.find("[vibrate]") != -1:
					currText = ""
					currLine = currLine.replace("[vibrate]", "")
					vibrate = true
					print("vibrate")

				currLine += "\n"

				visible_characters = 0
				currText += currLine
				targetChar = currLine.length()
				parse_bbcode(currText)
				curPos += 1
				lineAccTime = 0
				charAccTime = 0
				linePos = 0
				charComplete = false
				
				vibrateAccTime = vibrateWaitTime
				textComplete = curPos >= textSize
				print("Line Complete")
		else:
			if charAccTime < charWaitTime:
				charAccTime += delta
			else:
				charAccTime = 0
				#var advance = charsToSkip()
				var advance = 1
				#print(String(advance)+":"+currLine.substr(linePos, advance))
				visible_characters += 1
				targetChar -= advance
				linePos += advance
				
				if targetChar <= 0:
					charComplete = true
					charAccTime = 0
					lineAccTime = 0
					print("Char Complete")

			if vibrate:
				if vibrateAccTime < vibrateWaitTime:
					vibrateAccTime += delta
				else:
					vibrateAccTime = 0
					vibrate()
	else:
		if lineAccTime < lineWaitTime:
			lineAccTime += delta
		else:
			print("Text Done")
			start = false
			done = true
			clear()
			get_parent().hide()


func charsToSkip():
	if currLine[linePos] != "[":
		return 1

	var regexRes = imgRegex.search(currLine, linePos)

	if regexRes:
		return regexRes.get_string().length()

	regexRes = bbcodeRegex.search(currLine, linePos)

	if regexRes:
		return regexRes.get_string().length()

func vibrate():
	var mov = (randf() * 2.0 - 1.0) * vibrateMax 

	rect_position = textCenter + Vector2(0, mov)

func _on_Area2D_body_entered(body):
	triggered += 1
	if triggered == 1:
		reset_text(true)
