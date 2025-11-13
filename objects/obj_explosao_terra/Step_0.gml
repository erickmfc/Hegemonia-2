/// @description Verificar se deve tocar som (apenas no primeiro frame)
// ✅ CORREÇÃO: Tocar som apenas se não foi tocado ainda E sem_som for false
if (!som_tocado) {
    som_tocado = true; // Marcar como tocado
    
    // Verificar se deve tocar som
    var _sem_som = false;
    if (variable_instance_exists(id, "sem_som")) {
        _sem_som = sem_som;
    }
    
    // Verificar se está visível na câmera
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
            show_debug_message("🔊 Som de impacto terrestre: som_anti");
        } else {
            show_debug_message("❌ Som som_anti não encontrado!");
        }
    }
}
