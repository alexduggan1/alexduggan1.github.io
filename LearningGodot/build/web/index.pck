GDPC                �                                                                         P   res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn�"      ;	      ���G�����jN1�f    T   res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn   4      �      �b~��R�~ ��H�@    T   res://.godot/exported/133200997/export-48b73c06d84e347ac0d61b3b60fc8d74-arena.scn   �~      2      ���.��1���bJ�    P   res://.godot/exported/133200997/export-f46c71a9b7f0892a5bf2bd9cf0943875-ball.scn�      e      ]8��}�*�M��ݴX    P   res://.godot/exported/133200997/export-f4cf891e5f7a93b93d9b27cfb8401ccb-hud.scn `x      !      Sx�o���)HT����    ,   res://.godot/global_script_class_cache.cfg  `�             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex       �      �̛�*$q�*�́     H   res://.godot/imported/players.png-4257e6ff4eb9f5c0a1b4fac7ca83ce06.ctex �?      �7      �qS��-S��/.    H   res://.godot/imported/walls.png-c04d410442f6ce7c5383ee87e9bcd3a2.ctex   Ѝ      �       A6�CN;�Z��M��       res://.godot/uid_cache.bin  @�      @      -O�$+��≺{%��L       res://arena.tscn.remap  �      b       ]��K�)������q:�       res://ball.gd           �      �D8��b������>       res://ball.tscn.remap   @�      a       ;�#$�#ui�+�9KY)       res://hud.tscn.remap��      `       L�
�H��l�YB��       res://icon.svg  ��      �      C��=U���^Qu��U3       res://icon.svg.import   �      �       ��ֳ��h�iB�Q�A�       res://main.gd   �      �      ��z��Gy�L蹧[��       res://main.tscn.remap   ��      a       �J�Sw� ������       res://player.gd �+            ��p����gs�z��T       res://player.tscn.remap  �      c       ������T�?�L���       res://players.png.import�w      �       ��g���L�A3�>'#�       res://project.binary��      �      l$��Ԫ���K���       res://walls.png.import  p�      �       ��9$��9d��gh� .    extends RigidBody2D

var color
var screen_size
var speed = 150
var speed_default = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.scale = Vector2(0.375 * (screen_size.x / 1152), 0.375 * (screen_size.x / 1152))
	$CollisionShape2D.scale = Vector2(5 * 0.375 * (screen_size.x / 1152), 5 * 0.375 * (screen_size.x / 1152))
	speed = speed_default * (screen_size.x / 1152)
	position = get_viewport_rect().size / 2
	if(randi_range(0, 1) == 0):
		color = "red"
		linear_velocity = Vector2(speed, randf_range(-0.6, 0.6) * speed)
	else:
		color = "blue"
		linear_velocity = Vector2(-speed, randf_range(-0.6, 0.6) * speed)
	
	$AnimatedSprite2D.animation = color
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.animation = color

func _physics_process(delta):
	var collision_info = move_and_collide(linear_velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		print("collide")
		print(collision_info.get_collider().has_method("start"))
		if collision_info.get_collider().has_method("start"):
			print(collision_info.get_collider().player_num)
			if collision_info.get_collider().player_num == 1:
				color = "red"
			elif collision_info.get_collider().player_num == 2:
				color = "blue"



func checkForGoal():
	if position.x > screen_size.x:
		return 1
	if position.x < 0:
		return 2
	return 0
	pass


func _on_body_entered(body):
	if body.has_method("start"):
		if body.player_num == 1:
			color = "red"
		elif body.player_num == 2:
			color = "blue"
�����̆r��=�RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   friction    rough    bounce 
   absorbent    script    atlas    region    margin    filter_clip    animations    custom_solver_bias    radius 	   _bundled       Script    res://ball.gd ��������
   Texture2D    res://players.png �pMf$      local://PhysicsMaterial_fb3fs �         local://AtlasTexture_nnvyc �         local://AtlasTexture_yug7i          local://SpriteFrames_ryqfm K         local://CircleShape2D_5sjkm �         local://PackedScene_enaop �         PhysicsMaterial                      �?         AtlasTexture                                �B  �B         AtlasTexture                            �B  �B  �B         SpriteFrames                         name ,      blue       speed       A      loop             frames                   texture             	   duration      �?            name ,      red       speed       A      loop             frames                   texture             	   duration      �?         CircleShape2D             PackedScene          	         names "         Ball    collision_layer    collision_mask    physics_material_override    gravity_scale    continuous_cd    max_contacts_reported    contact_monitor    script    RigidBody2D    AnimatedSprite2D    sprite_frames 
   animation    CollisionShape2D    scale    shape    _on_body_entered    body_entered    	   variants                                                                   ,      red 
     �@  �@               node_count             nodes     -   ��������	       ����                                                                
   
   ����                                 ����      	      
             conn_count             conns                                       node_paths              editable_instances              version             RSRC��n)7�A/GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[ Oy�ӹ�f���[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://ckb22apbyd31i"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 LY�Ty9��=��Wextends Node

@export var player_scene : PackedScene
@export var ball_scene : PackedScene


var round_mode = "not started"

var p1Score = 0
var p2Score = 0

var p1
var p2

var ball

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.show()

func pressed_start():
	$StartButton.hide()
	new_game()

func new_game():
	p1Score = 0
	p2Score = 0
	
	p1 = player_scene.instantiate()
	add_child(p1)
	p2 = player_scene.instantiate()
	add_child(p2)
	
	p1.start(Vector2(-350, 0), 1)
	p2.start(Vector2(350, 0), 2)
	
	$RoundTimer.start(3)
	round_mode = "countdown"

func game_over(winner):
	round_mode = "ended"
	p1.queue_free()
	p2.queue_free()
	
	$StartButton.show()

func start_round():
	ball = ball_scene.instantiate()
	add_child(ball)
	round_mode = "going"

func someone_score(who):
	if(who == 1): p1Score += 1
	if(who == 2): p2Score += 1
	ball.queue_free()
	
	if p1Score >= 5:
		game_over(2)
	elif p2Score >= 5:
		game_over(2)
	else:
		$RoundTimer.start(3)
		round_mode = "countdown"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/ScoreLabel.text = str(p1Score) + "   -   " + str(p2Score)
	if round_mode == "countdown":
		$HUD/TimerLabel.text = str(ceili($RoundTimer.time_left))
	else:
		$HUD/TimerLabel.text = " "
	
	if round_mode == "going":
		ball = get_node("Ball")
		var did_score = ball.checkForGoal()
		if did_score == 1:
			someone_score(1)
		elif did_score == 2:
			someone_score(2)

func _on_round_timer_timeout():
	start_round()
1��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    device 
   window_id    alt_pressed    shift_pressed    ctrl_pressed    meta_pressed    pressed    keycode    physical_keycode 
   key_label    unicode    echo    script    events 	   _bundled       Script    res://main.gd ��������   PackedScene    res://player.tscn ����   PackedScene    res://ball.tscn ��7t���+   PackedScene    res://hud.tscn ��A �/HB   PackedScene    res://arena.tscn L!�69Mh      local://InputEventKey_6jhin �         local://Shortcut_80tjl �         local://PackedScene_gjf5w -         InputEventKey          ����	                          	   Shortcut                                PackedScene          	         names "   $      Main    script    player_scene    ball_scene    Node 
   ColorRect    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    color    StartTimer 
   wait_time 	   one_shot    Timer    StartButton    anchor_left    anchor_top    offset_left    offset_top    offset_right    offset_bottom 	   shortcut    text    Button    RoundTimer    HUD    Arena    _on_child_entered_tree    child_entered_tree    _on_start_timer_timeout    timeout    pressed_start    button_down    _on_round_timer_timeout    	   variants                                              �?         ���<���<��p=  �?     @@                  ?     @�     x�     @B     xA               Start Game                         node_count             nodes     e   ��������       ����                                        ����                     	      
                              ����                                 ����      	      
      
      
      
                           	      
                                    ����                           ���                      ���                    conn_count             conns                                                                 "   !                         #                    node_paths              editable_instances              version             RSRClJcextends RigidBody2D


@export var speed = 400
var player_num
var screen_size

var can_attack = true
var attacking = false
var attack_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.scale = Vector2(0.5 * (screen_size.x / 1152), 0.5 * (screen_size.x / 1152))
	$CollisionShape2D.scale = Vector2(5 * 0.5 * (screen_size.x / 1152), 5 * 0.5 * (screen_size.x / 1152))
	speed = speed * (screen_size.x / 1152)
	hide()

func start(pos, num):
	position = (get_viewport_rect().size / 2) + pos
	player_num = num
	can_attack = true
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movedir = Vector2.ZERO
	var attack = false
	if player_num == 1:
		$AnimatedSprite2D.play("red")
		if Input.is_action_pressed("P1MoveRight"):
			movedir.x += 1
		if Input.is_action_pressed("P1MoveLeft"):
			movedir.x -= 1
		if Input.is_action_pressed("P1MoveDown"):
			movedir.y += 1
		if Input.is_action_pressed("P1MoveUp"):
			movedir.y -= 1
		if Input.is_action_pressed("P1Attack"):
			attack = true
	elif player_num == 2:
		$AnimatedSprite2D.play("blue")
		if Input.is_action_pressed("P2MoveRight"):
			movedir.x += 1
		if Input.is_action_pressed("P2MoveLeft"):
			movedir.x -= 1
		if Input.is_action_pressed("P2MoveDown"):
			movedir.y += 1
		if Input.is_action_pressed("P2MoveUp"):
			movedir.y -= 1
		if Input.is_action_pressed("P2Attack"):
			attack = true
	
	if (movedir.length() > 0):
		movedir = movedir.normalized() * speed
	linear_velocity += movedir / 5
	if(linear_velocity.length() > speed):
		linear_velocity = linear_velocity.normalized() * speed
	else:
		linear_velocity *= 0.9
	if (can_attack):
		if (attack):
			attack_pos = position + linear_velocity.normalized() * speed * 0.3
			attacking = true
			can_attack = false
			$AttackCooldown.start(0.75)



func _integrate_forces(state):
	if attacking:
		state.transform.origin = attack_pos
		attacking = false

func _on_attack_cooldown_timeout():
	can_attack = true
x��ORSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    atlas    region    margin    filter_clip    script    animations    custom_solver_bias    radius 	   _bundled       Script    res://player.gd ��������
   Texture2D    res://players.png �pMf$      local://AtlasTexture_k8bt8          local://AtlasTexture_4ua11 `         local://AtlasTexture_sxnrh �         local://AtlasTexture_krxtq �         local://AtlasTexture_80k6b /         local://AtlasTexture_l4dym t         local://AtlasTexture_m6c0c �         local://AtlasTexture_dbc3x �         local://SpriteFrames_f81uc C         local://CircleShape2D_bntjw          local://PackedScene_qh2kq 9         AtlasTexture                                �B  �B         AtlasTexture                        �B      �B  �B         AtlasTexture                        pC      �B  �B         AtlasTexture                        �C      �B  �B         AtlasTexture                            �B  �B  �B         AtlasTexture                        �B  �B  �B  �B         AtlasTexture                        pC  �B  �B  �B         AtlasTexture                        �C  �B  �B  �B         SpriteFrames                         name ,      blue       speed       A      loop             frames                   texture              	   duration      �?            texture             	   duration      �?            texture             	   duration      �?            texture             	   duration      �?            name ,      red       speed       A      loop             frames                   texture             	   duration      �?            texture             	   duration      �?            texture             	   duration      �?            texture             	   duration      �?         CircleShape2D             PackedScene    
      	         names "         Player    collision_mask    gravity_scale    max_contacts_reported    contact_monitor    script    RigidBody2D    AnimatedSprite2D    sprite_frames 
   animation    CollisionShape2D    scale    shape    AttackCooldown 	   one_shot    Timer    _on_attack_cooldown_timeout    timeout    	   variants    	                                               ,      blue 
     �@  �@      	         node_count             nodes     0   ��������       ����                                                    ����         	                  
   
   ����                                 ����                   conn_count             conns                                      node_paths              editable_instances              version             RSRC���3�9����23GST2   �  �      ����               ��        �7  RIFF�7  WEBPVP8L�7  /��6�(h�F����E����?��m[�$I�&����\��\�說��m$G������Z�m[�yV��R	��ܵ��5h��ڸ��{�|M�A튌�޻׾/��  7�k��(Im�/`��3�ʤ��E�W{��7���I��Ip�H�$9s���L�=Օ���m$I��k=ٵ�>��_m�0��?��A1��M�;��{1�FR	Vcu��4���m#G��t\q���ݶm��m[Q|������VK�X�:�\���vk��ٶ�K�����=1�X�]f�6��d*�J��m�=�ϰm�d��u�vE#ۮ�f��>��Z"��Ŷh�6�� V�Km.��s��|�op�zI�=�_�L�m��I'PoC�q(J�d��j���B5����<���s%�Ħ>!g�L+"8b*q&�V�S�R���X6�106���?�rf)�)�-ę�T��ss�ʡ�dU�)ui��%M!�A���$�,#��}���eďHO�o�N��$_}R�O%���8Go���8�8�t�4�.���'�l�*_��Y�Q,|�~�3\I�b�
�ex��	�}�N7����p��*� ��\I��=8�O���gP���� ?V�V���鈀U�k@�U���1*��i�����v�/��q�p�A��:A(N�U�����ӣ��k}���x�/����ͳ��߯�pͿ]��\�sX} >�Q��(`'x����-*��*)����l�̗x������[�q�@���`�Q����s��;��5K̳�4ktآ�~�����h��TK��WM��8G��"�spP�v�$����+N�D�
/b��kCt�K�9n��^����~�l�l�KL���Zn���9 :<,0�~,<��o`���a�������;������o��z&��E�`G�z�nS���G��`�)k�~j-9��=����\f���+��T0��o ���o^���lѨ�m�a�����{l�Q�`7�JY���j��`I�=r�c����Y+-�В���r��X�Y+M�Ǹ'���#_���%"jYΤ��&��`w%�تWv�b������^��c��T����j�����RI�. ><(kP��7��Hgܶh��o��|
n{�JM��j�@%i$�#����z�K��h�󝏚z��v+������8_�|�$;�5�k�����Y��������ՠ4O��
��0L����{��g�N����4�~7�T!~�Cqv���R�KN#̯���n�-�hwFv�vso3��C$~��%��5Q�~v�p�!�U��Za?��SvI�S�Y+Ue���y0^�=Ǫ*�t!�5���oSo�E�kܶh0�j7��:P��uEU)�X]�Vr�������|d�y��.1��|��l&.�&����q�ġj�M@0�W�l?��OY�E/^��A��C��&]�g{�V�K���`H�t�\4_8�>n����0� �+eeS�a�<�~`����\c�F��yݍ�^/��骶��g���io�S���{}�Y�f;CM��I�`�[f{Ϯ�*�j�Y�J g�c�lq�ۚ��9�:\x��3s�6妮�*=0��N�7��h�ٮ1��|rp�i�YyR�U)���T��c���x�)�<kL�ت�7��򒕫r��`]�x磮w{��%X�i$W��]+_.�`-Pq�K�X�Z�w.r�e@x�(OVm�!Μ2.�`M�۹7�O���� ��1�jr�y��\�l.���1������._����X'�J�]����*։�3 ���^�Z~\x�k=�z��	i��f8�"N�a9��({�����GYr�A���$g�+�T�����F>���ڏ~P�JĦss�אF���%g�U�ٗ�9y6B8�C6��|{�M�S��l�챟J������U�TW'�Jo�˒s��m�yn�[.�MǧJM�y@����c�f 3�I?ju��Q։e6�
gS���1��q?����O���@�uuB���}�V�b- ��K����m�qݒ|A>��)
�N���73�^�ӝ{# 8��|��>��4�|��u�Я>��ޮ��:�^&GTZ��V���5[��m;����t�`�)f�F���|�q�]^Xf�5@ѳ�㗺���j
�/�ppDDj"��ODD�����2o�M�S��̽IZ�Yf�WL�H<Xp�R�оyq~�e[4���w]�,��Jϒد����U/���^V}yx�o����~*���f���u�iȾi���E�T�8u1�]k����c�{�T�ϱ:Tޘ/	$�zɯu_��j�	~>M����p~��}�=����?�͇�o�n��(�|>O�gkt��m��n�S�!.&��� ] �3�������ʗC��w>N�b0��������?� \i�-�����z�J�Zi�����Q (���̓���[��;�N� l�0�y��8�-/��_����S'٢ɠ^ѳ[�W��$�{�'���^��^#?E �
8�
� �٣z"3�Q]��Ƹ'�}igP�%�'2��c?e�d��d߀Sra_�Z猸z��n��,��q���[^@�W[[4���8�K8 |�k��ܫ����̽F���T|}�\�
&�;�A�5��p?$���G�!Q)���q-�|��q��-9K/�K΁ >���5!;J�����O?����>�*�21�o@�����������j-˩T���תu{�׫}���|�����H> �>WZ%
�I��r� ��4R�����R2|��(�&;YQ�uP�~
mc֙b�g,�So����2�NG�i��z(�t�c�Ś�n�/\����� Պ��/ y�=�s1HR!���K��@�[�;�k�$���zc;C�-zN�+��< vsoԛ�ܛ`�_���������|�/�qJ�]>�c8��V=��e�)�.�zU�K�H���[��-�I�.�bP��P�;6eU	�- �~k��k�@ �RQ�/�|�w�Mױ��g��K�KP��l�ޢ?���	�60�Vӓ/�7o�M���T��0�G|���~�:̳V	_��
6��Uk�&��E���/|�{K��k��j_ ��zc�y?�����Ɗw�������ԫ�ȥ�#��ף��?����Q����_}���|�?�q?��VƤ"j����\짬�̽I�`���%��5:%!ʇ���%��%�>Tފ�d�}��X�rϤH����G}�ݷ[ ��@z��|B���Ġ�S�C�A�%�� �}��;?�j?e��1���
����#�ۤ��Z(��@���p���Cm�ί��+�Z!��_�5/-|�3\�lg$$�f7�}H�����O�Ü�8��s�/�-�����A���?������:��c�@%�Ƽmا�]W G��9����J��
�����u��~+������{��4��ؕ4�}���O��@���w��·|�[߶�{�f��
����^y�xC9;��ADʾ����'�|p���!�;��޹X���
`#���F��0��E��_ �@�@� �z�E�>٢Iަ ���0��}o<�������}8+��%���G_��mg&��UwP����L��%��|k0�q�2�IqStx��-�qN�qOK�A%�^ǹ�w�#zf�cy:�z�~�z���Dtx��S@�k�i�I�/��Y�s������Ի�/�n�ʥ��Y+ď��Kfi�Y+�ʳVI�~H��>�s��^�3���`Y��B������q� ���K '|�;�]b��Yb��e�,1U�,9]@������v-��	���~�����g��&|�m���e�v�F������I�_���s��[� }lQ�/�. _~���*���p��'|a����T�/�S�_�w� �l�n�1 	��{�vݞ�O������/���_���_�_z�7Xr��/�8��+t��B�����G�Q�ߵ�Q��`ya��ߣH{x�Z�㽴{x��ĳV��:ο?.��K�{���z��n�[��IO���?�~	�X����綞��;t��O���gO�ϼ�c��ĸ'��8g$�����?>ǹ�]�8G��8�ų6�����eP� �4�J����3�z����;���;�%�*������t:15@��0��E=D��6HS��h�'[T I Mj�t�X	�i��� ����q�4%���1���'�X� ���}~����*�Fqn�b��rH�\�_��UE
l�b����g��U��o�*a�������o�����2ο���������_c����z�����o��P�MW̞����w8��t���Xx���]��zV1���v��팄� �M1��xJ}����87�r?m�q ���@%�����įy�>آ^�l� Q��S*�_����铹�#�oS�D�oso�#So$_=P#�s�W`uϛ#�Z!�LDD<���}/����ڨ|�A7��F��.��0�� G��D�U���r��ȑM��ѩG�蔄(F���#W�K���\8������8���E�f�>Yc,Dٷ�A+�i�鑩, �)�J�&��c�1�A@�mEpn��w��do7���n�7���aǮ�)�5�7�h���߈нPP����w��N��֠^Uϱ�l����t�����+i�b��߼�7��@�B�4����Z�˧Qu�!�7�c�ݭ�o�� z
�/%��c�Ś� ٷ����[�S���ݐzN��O~惱П{�ޘ{�p;U�w�<�B�#_�o>�ۿ�B5�8����.�~��_nz���5���@ ��b���w}EO�s1�}����W�zu�<a;Cſ�S�
,�;|�8�)avq��
�RMT�y��ϻ���8�K;�b�Z�S��S�V���b���O�w>&�0�r(҆�T������뇹7���ά"���֘�/֘���f��	��`P�-�tt_0��s�i��� �f�bɹ$�'̄3�띏�}[���~j<���־Q)|M*��guc���`]��U�yJ5&������nnQ�[4���v�	������艹�9�-�E��Ss����6 �4}��R��{��t������ �䔯�|P�,�,9W?,1�o=Cܜ�s� � ��Cv����>����<������< }�L�CL�G6 ��b�-r�N���P���W���c;��E�A�����"���x�s�bA��7�)�8�"����:�t`ŷ�S�Y� ��-����Π�H��c?���~j=�K�K>���r���[0�_�٦���j�<K��5�#F3H^��_�W j��w>R���8��]\���#a�<C��qϩR8x_�<uq�?_�lQq�U@ �1�0�R=�N%M��R��e?���7�F_�9M8x_xP2��<���Qw�*��*�����A=�l�[�3�}/���&gr�Գ�Y|����C~��|�� �}[�Ӵd�2�M[���Ã�Vӭ�*��GAVE8��O���~��� >��\�)O��|�e- ����?��+�.�����9� gR�,E8�O���y]��?�z꽀��-�R���_�Nq��	`kj�ƿ-1��Xb��`������<�N�be|��{ڏ>h�h4�1@luu�8t�7�.����I��q���O��Hlu��n�[|�M���U6��KE0�?:1�Sc�5�J)���T*�Sꂤi�q6�� @>7r˷�<ek"���v��>��7�9M㌣|N���_آ���R���ƷNs�6eS������q�آ�'��8�)�SW'P�rQ�5���u���c6��sor�Y��Zso���W7G�\�V*����w,���Xr�A�%_7O�\_�r��,qk��O��w>�:-�îrU.�S�����a��2�w>��ke����B7���h��p�Ӓ%�J=#�z��|��Ԙ{5��kr�RNq��`9�3�	���.�B���j:�8�K���(yr�C&τW U �~���m�9T�e� P��!�y�En�eF�}l�\�=�����h�˕��Ɂ}�����{�-\�����g��XeU.�S�������� �SkLt���7��> P��Q��%Ky4��8�i��;���o^�E�k��PSo������*FsϹR���#]P��7�3�^[T\�����Ձ�-�˘��ʥzJ]�<M
�ta�M͎{����[b�q*ߤ|E>��G�o�s��z��U��pi��Z��2��A�V��|��*%E�̓�g@��4,1�y��b�n�����v�R=�.M5��Q�4�6k�;����#�n9<D�'>�#W�F��j���Y�\�b?u��ʠ��z��	9�+�Jݜ��. �u��{��rjQ��o��|n��9�+�Z��crA�{�A����^��-*�N�w>j��ۭ�<�up#\ڹ�T���l)H��U��}�;��h��Y��ܛ�����uE���/\��͑"�_ ��Br�n���'4]L����'Ms�}�!988��y�\*��S����}�����2�>�Z坋-9����O���٢b�K���Ş��4��{ʠk��/�l��3��7͙��9���c�Y�m�����Y+<�<$u����X]�sU))88N#�+`8
���焩�x�
K,T���\�Y+M��8'�uU�LV����831��R=��r��[�Q��0`�/�}��~�s5��{Ft�nS���G��`M�%g�{��V!8�U5.�ss	88Nq��䙤��6ࢀ���~�#������m�}�"�t�/�o�s"���<0z����{�8�L�˫�,���ӭ�a�f���-���a��X��]��m�c�{IZ0'�6�XŹ���]��Z��+$���\����;�Υ��n:O:Oh�W�}~=ѷ�6*���{9;�g��x��������Yۭ�9�9����\ƾ�3|�7��e�����i�_��T�ħW���N��n�o#�ײ��1�}��kd�Fvc'v�#����:�7vc7v��mb�:v?������\�	���m:���c�^+�6�������q���_v�#�Z�Rm���]v��`w�}wj�_�y�`7v�}ɾ��%Zw'�2�6��%����I�߲?_vm���|o�j��)"%gv+9�o��3���mBB����N������a��&�Fd�v�$;�;���s�α3���<��d��7"�[�o3��ٍ}i���d_�(5�%��(h�K�_��~�ew�������c���e�nٽ��-췙�E�WǗ��|+��u���v�e�v����Wv��3���N΅�K�؉�ZoA�g�/ٍ�d'vc'vc7v*ߩ���~%tނR
�؍�Z�J�_��&����|e�8����������FΉ�.;��e'v�$gٗ쫆��`�j�ۆ��*�a��`��|˝٩v�&g�7���D)�g�2���&$��}��N��F��:/���j��fg����$�oe���?E"���*'�N�w$E��v}��H\Q��r�+J��7�N�+A�@\�$~ӕo+;��v�o��q��u9��ǔ;���ӔR�մ�>���մ��;�ryΤR��E�/���^��`
fa�`��!'���d��|�`�+#�T=�J$���r/�����1�n��s����Y���#7$� �Hn ��<�aU�����8g�
���q�.�M�p'�X@�>���Rg�P��w�R�?v}��s�2�@r7�����܈�@P�(8����3Qϙ��DgRF�9�p�~�'���(rCp��P��Bn(���橾i$_���0	��U�ǻ�}�Ŵg��d�R�M7U�d%���ं��3�����
u�ʣ�����wEg�f��{ۜ��%:v��l0�̞�^���t7�L��e��尵��9�尌\�I��3}���5�s��~03�����%:��=���Hd�C�ۍM-�Ξ;�q}���ͽS�m-a-�e�2O^���=k�Wϝ��p�����9��h��o*t�͑�!Y�p�Xph���ٟ���0g�
R�ެd��c���1m�a+n�5m��Ti?{ȓ����)�U��B�����z��<>�CB��ڶ}��U��g��\�0������IYX����0�x�.�j����i���k9OY���ߍ�깻`�f����?�<�ݙY�$�j��v8\�>�(>ӻ�}ۊہZ۷ό��H����-��`�9� ���5<�J�~-q[���������8��ֻf�\H�{������������1����Q����2�ֽ�8��o+ȧa:;g�iq�[q;\��0U��lR��ܧ�þ��VL��7����d�X-��n��i�T��'�*����;u]�n��[�{5�̦��2b9"��\����e����[�N�5Q�|�j��U���nk[q;�����練ᗰ��=g��*T� ̀��?ɸ�Y����c��u�d ��"U��s�j���K{��׻��3��{��{��$/J>\�6�gQ���}f��y�ۮڶ�vZmM��n8��S��@>�s�"�Pɱ�v���E��M�i���4���T0����"=���U��(̃
y��ൌYα]��׋��2;���±�h��q�D�A�&;��Z2V��e֩��6�j&�F��t��J�ʡr�a�z�(���\�eXx�*@.��e)�W"W�;;Y���k��r�����z�E��6�������g�F����XF/[q;��1����m�Y���`�$������|��=�p&�`���)�Ӟ���<$k`/�����\��M��H���dC�TR�o���HyH����h�*�Vڶ�vAm�m��ɓ�9�C%o��A⹷X��
��3<� � yg���u�3KP�w��WM��i;�vkڦEM���w�H[}3��ԕ��\�\Z5Ͻ�V�.���i8���Y�Or��%�r���7E��_T /��9�sH#����|�tU��.�G#�\y�����q�v���]Vk9<>)@)x	.��/H�R��w�Ho�N��������$�ʽ=E����H�
/��swqQ�kgxn}�C�NI|#�I\i������~l�N�_o�������e�� H3�2n��m��{�M6����w�
��X��ӝ* '�&8s��S������bU���UM��-��
"U�؝�-��p�����~(K'���sq�����-�= !��~w���MՀ��ʷ�8��J��<-�J���kZҤ�h��܏�yx�P�ؼ8���r�Zm���Y:}�cR�g �q�O�'�ǆku?Oշ�	86-��E�Q�����uP�3U�ƻ��=e1�K�a�z���!��f(�@���"�Ǉ�u?U�	n�{�6_ޙ$*F�}n~U{��?�z�|���P���`>uϖ�Kn�����,uD�q�����O��u��� �|%����81��|��6|'�����<| ��*楽�i~=i%yB�6ͳ0CV�\����z�ӊ��qM�`V�F��f_ܙT����X���u�֮0��"gn5W�K
H�������i~��"@���i����<�]�n���� �}igQ���u����O[q��&y�÷��T�gS
�}�xz�t5�I��4�sUkb��=���΢� ��i^���jZ����g�@�����!iB�#����5����	y2_;��;_?�o`a�%5���� ��������J��bח�B�])��COn߻�j-��T��ia�[��^E���#}Gy���b�g0I�P];������/�4��auk���6��#|�C�ִ�����}I�6&`��J����¸�ي[g5�iv|\܏@�v�eh�eX�]$\໐�pkET���֩'����T�w�m���?���zc�m8����W��*Y	�r3����6��L9��/�����W_��ͯ"+�A�}��?Ov[q�>Ou��\Qܑv�k��k��^]��[oLI5� �<Y��b�	�|˚����q>�;|�mM[lM�p2K�r%���`Z^��6��x� X�|�뵪7��/�}�F�#���n+n�{N�rCI\\ܕ!;��]�?�!���$|ȥqc� )�j�2r�eԒ��pY�W���ùdk	=�5��lR�\�l��ȸ���������$���$I�x�[���������uE��3��0-n���eM�&�\���2�'.=�L��lj%|?:��te�wf+���Κ����@�3�#���ѧ�}�5Tl�j..n$1|�m��C��d��k!��U������؊[����#�,�=��G�/�ju�c��6A�TK�?	x��hCw�L�z�={H��H���X�C��__D�I�����e�t�ɹO�S���2έ��dm�ze��Ԓ�3[����Ɏ|6�x~�D�R�%��Խ�@����t��������c+n���w��K~��*�vE	?H;̟����Ͻ���R�|�?6��џ��'�Z�=6��rA�T�k��C �v��;����'������	�;��[�~��>�IHnt��X۷x~ �jA���\�B��]!�)`1W�s���2[K藭5L�WtAp?���^}q�m��O�^u��8������`����~$_�๳ا÷�����G���sw�+ϽE�����8��>��z湣_rC0�k�e�V7�ٙ7T�2n�p}�3�!>�gƵM����ό�_޳����ro�����{N����p��|?Ow=�ޅ/�s��/ߛ� ���ZF�ܟߛ�^��:�F���X�|�w�zf���IK��S� l�]�S�<��k;����'/ᛶy���/��%m�ڀ�@�W��/��=��X�f��;����O0�p��|a�۱p��\���yk	l�@�W��/�u�����俗���S�Q��O�}o0O]������U�{$t��Fi���i��-�?�Gl�Q�m�0���Q��{��/��n������v������_�L������7\���#1V�^7U	��ǹ��?�n������wO��n�?�]|������=��z湳�wm�����_��G�m���BR)�y�a��+��4�Ns�z���
��Y�܏dnX4ȓ�}땵}SKnq����Z�n�Dܢ6Lg�J�n��I���I�����C�|��	� ��'�u�<4���T�-̂87!<]N�{��/�ۧ"OB\܏�^���T|*��r�d_0>���������e�C"��UMߟ	?� �|p��W����|�T������2A>��{�Qg����~��������4������(ׯ/"�疧�֏�P)�%�e��e�`^�BR�_�Y.A��w�>X;�Z�r֐�������O��]�G�����ӘVT=2�j@�����=7G޳��3��Ov�Y@�&�ڨ|��U���Nf	���0�����F
�/�^y���s&����2~�e┄`S,A~C"վ`���{��|%5��΂j_�eh�ehȾE&�qc��jơV�7�z����Ⱦ��΂v|��M�L�&� �n瓵:��.���HU'�W7-|�襻�H�K�}y��\�e�bk�٤�9Z!�F�O˫N�>�:�;��v|��Wo��z��K�}}�w��ۨ*�$�����c�n}~�o��H�D�	y�ٳk�	8���$��T�5m��5m×Y�M�%:�B�4�1���j8-v$5�\{���Ϋ���p�<�u��t�WT� �]b�bn	ȷ5�Ξ/ ��M=�e"�Q_��_�&k���m��@���D��p�o�{�0�C�5�$�D���w[K�/�,H�`]��k���5�o��ܖ���;����!��M��ӆ��/���5�0-m�q_�9���W�,㖾X�,�d�7C"��`8��]��}A,�yN�P�&Ԓn�S���G|�;%�>>/�j�m���G�gk߈�D"�N�?>*���J[�� |�����|�gA��l�I�}�
����;����}
���w=1-l~��H��W)�i^�ӂ&I�/R˧�ڗA~@?�̭�=� ??�+8!5�����~�{&��W�i#�*�a��$;�Ma`��,>��\�Td%̀T���H�,���뀯�\(?����^X�a8���9�C�}0�v�˄��e��_I�<��z�~t�^n�� �o��Z}qg��F����bk�4��K�W���ݚ.�𗤃��24��������F3"�'���<Չ��������s�k�j��Y�z�p#���s���;�S��������`��R�
R������J�|�.>�	�}���s:�|a����y����Ҩ3M�
$XO�4���2,\����~(��AP	������'�͕�Ԉ�=�v|�t�%Z
{A�iI��v�����L;huk�@�c8�,�+Y�/y���PT���+X/ъ�J�e�ܸ��`Z��o�3�ϑ��iP��bU}��j
�<�:��W�+P��$AZ�̽�u̽��?	�%�����Q����[�E�빷�h�]���d�e�;$I:���H�D���.�f[��z��r��Ε��"�$	.Ρʓi~wэ���iA���Hᢘ�"���u���%�k8�]��{�rOf_r��R���� �࢔���b-��ϊ�3W�2͑B��\�ܕ7�:$<w ��#?��#ΐ{{�f��*��w�����ZR�F"�h��9ᛞ*�MD�u�p*K�e��\�T�(ukaouc^����7T�%�)/���)�..���Nf�;��_���k�D�!(�F��8[�rW5�|���M�:y�s���e�T]�e0r=w'����!Z�iq.X�dZ�T��$	����x~�Z��m��_��1�RQ�b4!����-;�/�e�r>����G�+JT�F�)�1pK��]dZڬ�y�۴��]$`n�$(����*G�����*����k���2by�XL �|a����2�9�DU9�%���};�նqU#Or�ܱ��h�9E�z��v>��I���3L�&��i@>
Œ8M�'V:����o����_�a[i����� ��K�Wm3�/e�s>D���+����ִ��l�L�3�N΂�8��r�*�%�S����q���Lu� �
~Q��U�
:��#����U6������Q˴��eG���V��7ǹ:�|�/������s��l/�ji�����r?f�4�7�C��������.��-P�A*+��
j��Ne��_�Ǉ�t�ؾwLc���ԏ�Q�|AΑPΙ�d�~�&S�Y���,��Ti�E<?�w'T8���%r������M��}��;��T������p2� ��_�[�ԾpK��s�g�=Ÿ�z���7O��e���ak	[KX��2j��-ߛ���n�X=�É,����M�}Ӝ���)u�"��?޳�C˄�3�����"�\��ԭ����+��~4{�.�ջ�����Z�S��Mӻ���swq��c���D׮�SP��nMn5��Ă9��p�7˹����Y��1V��������Ti?{ȓ�r�#-1XFv��ं��]��e�H���'�Ӄ�a�9�����螯<�ʞ;�qm��ͽ�<eYF-k9���尌Z�)��;}�w�湣�����:�]�i��PW,HH0@.��3�1r)�gF�����շ	�r�<O�e�;���szݙ�E�e0q�/L�e0HҐ��ϙ+G
����p-<v�(\C6Ư��*T]\�EJ�	�����=����9����/<ג����q�.�&��h)|�Sm�4��}Et)�܏����N��?_�h�/Y��{`z�w�9��3�o�9B)��!�?��;s��6n��������L��'�n���m��T6hiC�EA������Vn�?־�G���-�fXT|I�|�-sN�A� 7L�s;~�r۸a�ɹ�� �i[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bdcpwp31rdnsa"
path="res://.godot/imported/players.png-4257e6ff4eb9f5c0a1b4fac7ca83ce06.ctex"
metadata={
"vram_texture": false
}
 �c
�Dc��Wֆ�RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script 	   _bundled           local://LabelSettings_5vy6m �         local://LabelSettings_ogp6v �         local://PackedScene_ja7gx          LabelSettings          <            LabelSettings          P            PackedScene          	         names "         HUD    CanvasLayer    ScoreLabel    anchors_preset    anchor_left    anchor_right    offset_left    offset_right    offset_bottom    grow_horizontal    text    label_settings    horizontal_alignment    vertical_alignment    Label    TimerLabel    anchor_top    anchor_bottom    offset_top    grow_vertical    	   variants                   ?     ��     �A     �A            5 - 0                            ��     P�     �@     PA      3                node_count             nodes     I   ��������       ����                      ����                                        	      
                                          ����      	                              
                     	            
                                  conn_count              conns               node_paths              editable_instances              version             RSRC�Jܵ�����HN�RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script    atlas    region    margin    filter_clip    animations 	   _bundled    
   Texture2D    res://walls.png zELC�i	      local://RectangleShape2D_88guw �         local://AtlasTexture_e7u6w �         local://SpriteFrames_kg6yr #         local://RectangleShape2D_k0h2w �         local://AtlasTexture_egyb3          local://AtlasTexture_d3pxn V         local://SpriteFrames_xh0wf �         local://RectangleShape2D_lf7w6          local://PackedScene_xo28u 6         RectangleShape2D       
    @�D  �B         AtlasTexture                                 HD  �B         SpriteFrames    	                     name ,      default       speed      �@      loop             frames                   texture             	   duration      �?         RectangleShape2D             AtlasTexture                         �C      �C  �B         AtlasTexture                                 �C  �B         SpriteFrames    	                     name ,      blue       speed      �@      loop             frames                   texture             	   duration      �?            name ,      red       speed      �@      loop             frames                   texture             	   duration      �?         RectangleShape2D       
     C @0D         PackedScene    
      	         names "         Arena    Node2D    Wall1    collision_layer    collision_mask    gravity_scale    continuous_cd    lock_rotation    freeze    RigidBody2D    CollisionShape2D 	   position    shape    AnimatedSprite2D    scale    sprite_frames    Wall2    Wall3 	   rotation 
   animation    Wall4    Wall5    Wall6    PlayerBounds    PlayerBounds2    	   variants                                
     D  �A          
       �(4�
   {�?{�?         
     D  D
       �(4B
    �D  ��   �I?
   �~�A��A         
   ��L=��J>         ,      blue 
     C  ��   �I�,      red 
         �?
     C �)D   ���
       *  @
    �D �)D   ��@      
     �� ��C         
     �D  �C      node_count             nodes     M  ��������       ����                	      ����                                                    
   
   ����                                ����                                 	      ����                                                    
   
   ����      	                          ����      
                           	      ����                                                    
   
   ����                                            ����                                 	      ����                                             
       
   
   ����                                            ����                                 	      ����                                                          
   
   ����                                            ����                                 	      ����                                                          
   
   ����                                            ����                                 	      ����                                
   
   ����                           	      ����                                
   
   ����                         conn_count              conns               node_paths              editable_instances              version             RSRC��ni��R�����GST2      d      ����                d        ^   RIFFV   WEBPVP8LI   /� 0b��N�0����gf��jj"IR.>����FO�� �� nta�Ϥ���}�}�}��~�} ���Pӽ�5[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dglq0qnnnaifa"
path="res://.godot/imported/walls.png-c04d410442f6ce7c5383ee87e9bcd3a2.ctex"
metadata={
"vram_texture": false
}
 �`a_�Re7R���^[remap]

path="res://.godot/exported/133200997/export-f46c71a9b7f0892a5bf2bd9cf0943875-ball.scn"
���o�r����g[remap]

path="res://.godot/exported/133200997/export-3070c538c03ee49b7677ff960a3f5195-main.scn"
���nv<d�jT 0U[remap]

path="res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn"
:������g�f�V[remap]

path="res://.godot/exported/133200997/export-f4cf891e5f7a93b93d9b27cfb8401ccb-hud.scn"
[remap]

path="res://.godot/exported/133200997/export-48b73c06d84e347ac0d61b3b60fc8d74-arena.scn"
��ː:s��	�list=Array[Dictionary]([])
@ �N�<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
�t�W�Q�C   ��7t���+   res://ball.tscn���'zL   res://icon.svg]mkX�
g   res://main.tscn����   res://player.tscn�pMf$   res://players.png��A �/HB   res://hud.tscnzELC�i   res://walls.pngL!�69Mh   res://arena.tscnpc�P��+/   res://Export/LearningGodotWeb1/Web 1.0.icon.png6�]�A��n;   res://Export/LearningGodotWeb1/Web 1.0.apple-touch-icon.png�w�4��&*   res://Export/LearningGodotWeb1/Web 1.0.png5��1�?*   res://Export/LearningGodotW/index.icon.png�ƦE��6   res://Export/LearningGodotW/index.apple-touch-icon.png�_{2��%   res://Export/LearningGodotW/index.pngECFG      application/config/name         LearningGodot      application/run/main_scene         res://main.tscn    application/config/features(   "         4.1    GL Compatibility       application/config/icon         res://icon.svg     display/window/size/resizable             input/P1MoveRight�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script         input/P1MoveUp�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script         input/P1MoveDown�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/P1MoveLeft�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/P1Attack�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   C   	   key_label             unicode    c      echo          script         input/P2MoveRight�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/P2MoveUp�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/P2MoveDown�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/P2MoveLeft�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/P2Attack�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   L   	   key_label             unicode    l      echo          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility�vDӶ�x