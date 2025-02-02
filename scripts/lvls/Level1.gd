extends Node2D

@onready var line = $Line2D
@onready var polygon = $Line2D/Polygon2D
@onready var collision_polygon = $Line2D/StaticBody2D2/CollisionPolygon2D
var Game_start = false
var timer = 0.0
var timer_start_game = 0.0
var timer_playing_lvl = 0.0
var bone_textures = [
	preload("res://assets/sprite/undergrounds/skeleton_0000_skull.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0001_hand-closed.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0002_hand-open.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0003_arm-lower.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0004_arm-upper.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0005_ribcage.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0006_leg-upper.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0007_pelvis.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0008_abdomen.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0009_leg-lower.png"),
	preload("res://assets/sprite/undergrounds/skeleton_0010_foot.png"),

]
@export var bone_count: int = 15  # Количество костей
@export var min_scale: float = 0.5  # Минимальный масштаб
@export var max_scale: float = 1.0  # Максимальный масштаб
@export var min_rotation: float = -45  # Минимальный угол поворота (в градусах)
@export var max_rotation: float = 45  # Максимальный угол поворота (в градусах)
@export var y_offset: float = 100.0 





var line_points
var bottom_y

func _ready() -> void:
	generate_polygon_and_collision()
	generate_bones_under_line()
	GlobalPlayer.player_died = false
	


	Bridge.game.connect("visibility_state_changed", Callable(self, "_on_visibility_state_changed"))

# To track visibility state changes, connect to the signal

func _on_visibility_state_changed(state):
	if state == 'hidden':
		$AudioStreamPlayer.volume_db = -80.0
	elif state == 'visible':
		$AudioStreamPlayer.volume_db = -23.0
		
func generate_polygon_and_collision():
	line_points = line.points
	
	if line_points.size() < 2:
		return
	
	var polygon_points = line_points.duplicate()
	
	bottom_y = 20000  # Нижняя граница земли
	polygon_points.append(Vector2(line_points[-1].x, bottom_y))  # Правая нижняя точка
	polygon_points.append(Vector2(line_points[0].x, bottom_y))   # Левая нижняя точка
	
	# Устанавливаем точки для Polygon2D
	polygon.polygon = polygon_points
	
	# Устанавливаем точки для CollisionPolygon2D
	collision_polygon.polygon = polygon_points






func _process(delta: float) -> void:
	$"InGameUI/StoneLabel".text = str(": ", int(Global.Stones))
	$"InGameUI/CoinLabel".text = str(": ", int(Global.coins))
	
	if Game_start == false and Global.Stones < 5:
		timer_start_game += delta
		if timer_start_game >= 10:
			lose("Ты не собрал камни")
	else:
		Game_start = true
	
	if Global.Stones <= 2 and Game_start == true:
		timer += delta
		if timer >= 1:
			lose("Ты слишком много \n потерял камней")
	else:
		timer = 0
	
	$ParallaxBackground.position.y = $Player.position.y * 0.01


func lose(reason: String):
	$"UI_lose/LOSE/Label".text = reason
	$UI_lose.visible = true
	GlobalPlayer.player_died = true
	Game_start = false


func _on_area_finish_body_entered(body: Node2D) -> void:
	if "layer" in body.name:
		$UI_win.visible = true
		$UI_win.stars_anim()
		$InGameUI.visible = false
		Global.passedLvl += 1
		Global._save_data()



func generate_bones_under_line():
	var line_points = $Line2D.points  # Получаем точки из Line2D
	if line_points.size() < 2:
		return

	# Находим минимальную и максимальную X-координаты линии
	var min_x = line_points[0].x
	var max_x = line_points[0].x
	for point in line_points:
		if point.x < min_x:
			min_x = point.x
		if point.x > max_x:
			max_x = point.x

	# Размещаем кости
	for i in range(bone_count):
		var random_x = randf_range(min_x, max_x)  # Случайная X-координата
		var random_y = get_line_height_at_x(random_x) + y_offset  # Y-координата под линией
		var random_scale = randf_range(min_scale, max_scale)  # Случайный масштаб
		var random_rotation = deg_to_rad(randf_range(min_rotation, max_rotation))  # Случайный поворот
		var random_texture = bone_textures[randi() % bone_textures.size()]  # Случайная текстура

		spawn_bone(Vector2(random_x, random_y), random_scale, random_rotation, random_texture)

func get_line_height_at_x(x: float) -> float:
	var line_points = $Line2D.points
	for i in range(line_points.size() - 1):
		var start_point = line_points[i]
		var end_point = line_points[i + 1]
		if x >= start_point.x and x <= end_point.x:
			# Линейная интерполяция для нахождения Y на отрезке
			var t = (x - start_point.x) / (end_point.x - start_point.x)
			return lerp(start_point.y, end_point.y, t)
	return line_points[-1].y  # Если X за пределами линии, вернуть Y последней точки

func spawn_bone(position: Vector2, scale: float, rotation: float, texture: Texture2D):
	var bone_sprite = TextureRect.new()  # Создаём новый спрайт
	bone_sprite.texture = texture  # Назначаем текстуру
	bone_sprite.position = position  # Устанавливаем позицию
	bone_sprite.scale = Vector2(scale, scale)  # Устанавливаем масштаб
	bone_sprite.rotation = rotation  # Устанавливаем поворот
	add_child(bone_sprite)  # Добавляем спрайт на сцену
