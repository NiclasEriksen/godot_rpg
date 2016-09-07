tool
extends Node2D
export(float) var value = 0.0 setget setValue
export(int,1,4) var precision = 2 setget setPrecision
export(Color) var modulate = Color(1,1,1) setget setModulate
export(float,0.0, 99999.9) var step = 1.0
var _numbers = []
var _timer = null
var _target_value = value
var Number = preload("res://addons/dynamic_number/number.tscn")

func dynamic_set(v, duration):
	if _timer != null:
		_timer.stop()
		_target_value = v
		if _target_value < value:
			step = -abs(step)
		else:
			step = abs(step)
		_timer.set_wait_time(float(duration)/(abs(_target_value-value)/abs(step)))
		_timer.set_one_shot(false)
		_timer.start()

func stop_set():
	if _timer != null:
		_timer.stop()
		self.value = _target_value

func setValue(v):
	value = v
	var sv = str(v)
	var dotPos = sv.find(".")
	if dotPos != -1:
		sv = str(sv.substr(0,dotPos))
		if precision > 0:
			sv += str(v).substr(dotPos,precision+1)
	if sv.length() <= _numbers.size():
		for i in range(sv.length()):
			_numbers[i].set_frame(getFrameIndex(sv.substr(i,1)))
		for j in range(sv.length(),_numbers.size()):
			_numbers[j].set_frame(13)

func setPrecision(p):
	if p >= 0 and p <= 4 and precision != p:
		precision = p
		setValue(value)

func setModulate(color):
	for n in _numbers:
		n.set_modulate(color)
	modulate = color

func getFrameIndex(c):
	if c.length() >1 or c.length() == 0:
		return 13
	elif c == ".":
		return 10
	elif c == "-":
		return 11;
	elif c == "x" or c == "X":
		return 12
	else:
		return c.to_int()

func _ready():
	for i in range(10):
		var c = Number.instance()
		c.set_pos(Vector2(i*34,0))
		c.set_name(str("Number",i))
		add_child(c)
		_numbers.append(c)
	_timer = Timer.new()
	_timer.connect("timeout", self, "_stepUpdate")
	setValue(value)
	setModulate(modulate)

func _stepUpdate():
	if abs(_target_value - value) <= abs(step):
		_timer.set_one_shot(true)
		self.value = _target_value
	else:
		self.value = value + step