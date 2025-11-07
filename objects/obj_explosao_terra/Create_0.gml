// Explosão no solo (poeira + chamas)
// ✅ CORREÇÃO: Tocar som apenas se a explosão estiver visível na câmera
// Verificação inline (sem depender de script)
var _cam = view_camera[0];
var _visivel = true; // Fallback: considerar visível
if (_cam != -1 && _cam != noone) {
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    if (_cam_w > 0 && _cam_h > 0) {
        var _margin = 100;
        var _view_left = _cam_x - _margin;
        var _view_right = _cam_x + _cam_w + _margin;
        var _view_top = _cam_y - _margin;
        var _view_bottom = _cam_y + _cam_h + _margin;
        _visivel = (x >= _view_left && x <= _view_right && y >= _view_top && y <= _view_bottom);
    }
}

// ✅ NOVO: Verificar se deve tocar som (removido para mísseis do F-5)
var _sem_som = false;
if (variable_instance_exists(id, "sem_som")) {
    _sem_som = sem_som;
}

if (_visivel && !_sem_som) {
    var _sound_index = asset_get_index("som_anti");
    if (_sound_index != -1) {
        audio_play_sound(som_anti, 1, false);
        show_debug_message("🔊 Som de impacto terrestre: som_anti");
    } else {
        show_debug_message("❌ Som som_anti não encontrado!");
    }
}

// Poeira
for (var i = 0; i < 12; i++) {
    var fx = instance_create_layer(x, y, "Efeitos", obj_fumaca_missil);
    fx.image_blend = c_gray;
    fx.vspeed = random_range(-2, -0.5);
    fx.hspeed = random_range(-1.5, 1.5);
}

// Fogo central
part_type = part_type_create();
part_type_shape(part_type, pt_shape_explosion);
part_type_size(part_type, 0.8, 1.5, 0, 0);
part_type_color1(part_type, c_red);
part_type_color3(part_type, c_red, c_yellow, c_orange);
part_type_alpha2(part_type, 1, 0);
part_type_speed(part_type, 1, 4, 0, 0);
part_type_direction(part_type, 0, 360, 0, 0);
part_type_life(part_type, 15, 25);

part_sys = part_system_create();
part_system_depth(part_sys, depth - 1);

// ✅ OTIMIZAÇÃO: Reduzir partículas baseado em LOD
var _lod_level = scr_get_lod_level();
var _particle_count = 40;
if (_lod_level == 1) _particle_count = 20; // Metade em zoom médio
else if (_lod_level == 0) _particle_count = 5; // Mínimo em zoom muito afastado

part_particles_create(part_sys, x, y, part_type, _particle_count);

alarm[0] = game_get_speed(gamespeed_fps) * 1.5; // 1.5 segundos
