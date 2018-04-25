extends KinematicBody

var moveSpeed = 0.0
var destPos = Vector3()
var yVel = 0

var HP = 100
var HP_max = 100
var entity_name = ""

var hp_label
var name_label

var custom_font = preload("res://yetgul.tres")

func _ready():
	hp_label = Label.new()
	name_label = Label.new()
	#var f = load("res://Symbola.tres")
	#f.size = 20
	hp_label.add_font_override("font", custom_font)
	#hp_label.align = HALIGN_CENTER
	#hp_label.valign = VALIGN_CENTER
	hp_label.add_color_override("font_color", ColorN("red"))
	name_label.add_color_override("font_color", ColorN("yellow"))
	hp_label.hide()
	name_label.hide()
	add_child(hp_label)
	add_child(name_label)
	pass

func _process(delta):
	#jump
	yVel -= 40*delta
	translate_object_local(Vector3(0,yVel*delta,0))
	if translation.y <= 1.5:
		translation.y = 1.5
		yVel = 0
	#move
	var destPos = self.destPos
	destPos.y = self.translation.y
	var dist = self.translation.distance_to(destPos)
	if dist > 0.01:
		var delta_speed = moveSpeed*delta
		var dir = (destPos - self.translation).normalized()
		if dist > delta_speed:
			self.translation += dir * delta_speed
		else:
			self.translation = destPos
	else:
		self.translation = destPos
	
	#labels
	if not has_node("../Player/Camera"):
		return
	var camera = get_node("../Player/Camera")
	var worldPos = self.translation + Vector3(0,$MeshInstance.get_aabb().size.y/2+1.5,0)
	var screenPos = camera.unproject_position(worldPos)
	if not get_viewport().get_visible_rect().grow(100).has_point(screenPos):
		name_label.hide()
		hp_label.hide()
		return
	name_label.show()
	hp_label.show()
	
	hp_label.text = str(HP)+"/"+str(HP_max)
	hp_label.rect_position = screenPos - Vector2(hp_label.rect_size.x/2, 0)
	#hp_label.rect_position.x -= hp_label.rect_size.x/2
	name_label.text = entity_name
	name_label.rect_position = screenPos - Vector2(name_label.rect_size.x/2,hp_label.rect_size.y + 3)
	#name_label.rect_position.x -= name_label.rect_size.x/2