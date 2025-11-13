// Explosão aérea (fogo e partículas)
// ✅ CORREÇÃO: Inicializar sem_som como false por padrão
if (!variable_instance_exists(id, "sem_som")) {
    sem_som = false; // Inicializar como false se não existir
}

// ✅ CORREÇÃO: Tocar som apenas uma vez no Create Event (se não tiver flag sem_som)
// Verificar se está visível na câmera antes de tocar
var _sem_som = sem_som;
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

// Tocar som apenas se visível E sem_som for false
if (_visivel && !_sem_som) {
    var _sound_index = asset_get_index("som_anti");
    if (_sound_index != -1) {
        audio_play_sound(som_anti, 1, false);
    }
}

// ✅ CORREÇÃO: Efeito de luz / partículas - LIMITADO a 5-10 partículas
part_type = part_type_create();
part_type_shape(part_type, pt_shape_explosion);
part_type_size(part_type, 0.5, 1.5, 0, 0);
part_type_color1(part_type, c_orange);
part_type_alpha2(part_type, 1, 0);
part_type_speed(part_type, 2, 5, 0, 0);
part_type_direction(part_type, 0, 360, 0, 0);
part_type_life(part_type, 15, 25);

part_sys = part_system_create();
part_system_depth(part_sys, depth - 1);

// ✅ CORREÇÃO: Limitar partículas a 5-10 (reduzido drasticamente)
var _lod_level = scr_get_lod_level();
var _particle_count = 8; // Máximo de 8 partículas
if (_lod_level == 1) _particle_count = 5; // 5 em zoom médio
else if (_lod_level == 0) _particle_count = 3; // 3 em zoom muito afastado

// ✅ CRÍTICO: Criar partículas apenas UMA VEZ no Create Event
part_particles_create(part_sys, x, y, part_type, _particle_count);

// ✅ CORREÇÃO: Alarm para destruir após 1-2 segundos (60-120 frames a 60 FPS)
alarm[0] = 90; // 1.5 segundos (90 frames a 60 FPS)
