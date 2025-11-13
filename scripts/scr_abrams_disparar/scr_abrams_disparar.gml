/// @description Dispara projétil SABOT do M1A Abrams
/// @return {Id.Instance} ID do projétil criado ou noone

function scr_abrams_disparar() {
    // Verificar se tem alvo válido
    if (alvo == noone || !instance_exists(alvo)) {
        return noone;
    }
    
    // Calcular posição de spawn do projétil (ponta do cano)
    // Assumindo que o cano tem ~30 pixels de comprimento na direção da torre
    var _comprimento_cano = 30;
    var _spawn_x = x + lengthdir_x(_comprimento_cano, angulo_torre);
    var _spawn_y = y + lengthdir_y(_comprimento_cano, angulo_torre);
    
    // Obter projétil do pool ou criar novo
    var _obj_tiro_tanque = asset_get_index("obj_tiro_tanque");
    if (_obj_tiro_tanque == -1) {
        show_debug_message("⚠️ ERRO: obj_tiro_tanque não encontrado!");
        return noone;
    }
    
    var _projetil = scr_get_projectile_from_pool(_obj_tiro_tanque, _spawn_x, _spawn_y, layer);
    
    if (!instance_exists(_projetil)) {
        show_debug_message("⚠️ ERRO: Falha ao criar projétil!");
        return noone;
    }
    
    // Configurar projétil
    _projetil.direction = angulo_torre;
    _projetil.speed = 15; // Projétil SABOT é mais rápido
    _projetil.dano = 120; // Dano maior que tanque comum
    _projetil.dano_area = 70; // Dano de área para explosão
    _projetil.raio_area = 90; // Raio de explosão maior
    _projetil.eh_tiro_tanque = true; // Flag para identificar tiro de tanque
    _projetil.alvo = alvo; // Manter alvo
    _projetil.image_blend = c_yellow; // Cor amarela para diferenciar
    
    // ✅ NOVO: Trocar sprite para spr_projetil_sabot
    var _spr_sabot = asset_get_index("spr_projetil_sabot");
    if (_spr_sabot != -1 && sprite_exists(_spr_sabot)) {
        _projetil.sprite_index = _spr_sabot;
    }
    
    // Resetar timer de vida
    if (variable_instance_exists(_projetil, "timer_vida")) {
        _projetil.timer_vida = 150; // Timer de vida (2.5 segundos)
    }
    
    // ✅ Tocar som apenas se a unidade estiver visível na câmera
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
    
    if (_visivel) {
        var _snd_tiro_abrams = asset_get_index("snd_tiro_abrams");
        if (_snd_tiro_abrams != -1) {
            audio_play_sound(_snd_tiro_abrams, 5, false);
        }
    }
    
    if (global.debug_enabled) {
        show_debug_message("💥 M1A Abrams DISPAROU SABOT! Dano: " + string(_projetil.dano));
    }
    
    return _projetil;
}

