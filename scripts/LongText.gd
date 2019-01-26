extends RichTextLabel

# class member variables go here, for example:
# var a = 2
export(float, 0, 20, 0.01) var lineWaitTime = 2
export(float, 0, 1, 0.00001) var charWaitTime = 0.001
export(String, MULTILINE) var longText
export(bool) var start = false
export(bool) var startOnFirstLine = false
export(bool) var done = false

var arrText = []
var currText = ""
var curPos = 0
var targetChar = 0

var lineAccTime = 0
var charAccTime = 0
var charComplete = false
var textSize = 0
var textComplete = false
var linePos = 0
var currLine = ""

var imgRegex = RegEx.new()
var bbcodeRegex = RegEx.new()
var charWaitRegex = RegEx.new()
var lineWaitRegex = RegEx.new()

var background = null

func reset_text(state):
	start = state
	done = false
	config_text()
	if background == null:
		background = get_parent()
	
	if start:
		background.show()
		show()
	else:
		background.hide()
		hide()

func _ready():
	reset_text(start)
	

func config_text():
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
	else:
		if lineAccTime < lineWaitTime:
			lineAccTime += delta
		else:
			print("Text Done")
			start = false
			done = true
			clear()


func charsToSkip():
	if currLine[linePos] != "[":
		return 1
	
	var regexRes = imgRegex.search(currLine, linePos)

	if regexRes:
		return regexRes.get_string().length()

	regexRes = bbcodeRegex.search(currLine, linePos)

	if regexRes:
		return regexRes.get_string().length()
	
	

