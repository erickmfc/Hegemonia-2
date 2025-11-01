// =============================================
// STEP - Gerenciar Standby de Unidades Inimigas
// =============================================

if (!standby_enabled) exit;

// Atualizar timer
timer_check--;
if (timer_check > 0) exit;

timer_check = check_interval;

// Resetar contadores
units_in_standby = 0;
units_activated = 0;

// Obter informações da câmera
var cam = view_camera[0];
if (cam == noone) exit;

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);
var cam_center_x = cam_x + cam_w / 2;
var cam_center_y = cam_y + cam_h / 2;

// === TIPOS DE UNIDADES MILITARES ===
var _unit_types = [
    obj_infantaria,
    obj_tanque,
    obj_soldado_antiaereo,
    obj_blindado_antiaereo,
    obj_helicoptero_militar,
    obj_caca_f5,
    obj_f6,
    obj_f15,
    obj_c100,
    obj_lancha_patrulha,
    obj_navio_base,
    obj_submarino_base,
    obj_navio_transporte
];

// Verificar se obj_fragata existe antes de adicionar
var _obj_fragata = asset_get_index("obj_fragata");
if (_obj_fragata != -1 && asset_get_type(_obj_fragata) == asset_object) {
    array_push(_unit_types, _obj_fragata);
}

// === PROCESSAR CADA TIPO ===
for (var i = 0; i < array_length(_unit_types); i++) {
    var _obj_type = _unit_types[i];
    
    if (!object_exists(_obj_type)) continue;
    
    with (_obj_type) {
        // ✅ IGNORAR unidades do jogador
        if (!scr_is_enemy_unit(id)) continue;
        
        // ✅ NÃO colocar em standby se está patrulhando
        if (scr_is_unit_in_patrol(id)) {
            // Manter ativa se está patrulhando
            instance_activate_object(id);
            if (!variable_instance_exists(id, "standby_mode")) {
                standby_mode = false;
            }
            continue;
        }
        
        // ✅ NÃO colocar em standby se está em combate
        var _in_combat = false;
        if (variable_instance_exists(id, "alvo") && alvo != noone && instance_exists(alvo)) {
            _in_combat = true;
        }
        if (variable_instance_exists(id, "alvo_em_mira") && alvo_em_mira != noone && instance_exists(alvo_em_mira)) {
            _in_combat = true;
        }
        if (variable_instance_exists(id, "estado")) {
            if (estado == "atacando" || estado == "caçando" || estado == "movendo_para_alvo") {
                _in_combat = true;
            }
        }
        
        if (_in_combat) {
            instance_activate_object(id);
            if (!variable_instance_exists(id, "standby_mode")) {
                standby_mode = false;
            }
            continue;
        }
        
        // Calcular distância da câmera
        var _dist = point_distance(x, y, cam_center_x, cam_center_y);
        
        // === LÓGICA DE STANDBY ===
        if (_dist > standby_distance) {
            // ✅ FORA DA TELA - ENTRAR EM STANDBY
            if (!variable_instance_exists(id, "standby_mode") || !standby_mode) {
                standby_mode = true;
                obj_enemy_standby_manager.units_in_standby++;
            }
            
            // ✅ Simplificar Step event (será feito no próprio Step da unidade)
            // Não desativar completamente - apenas marcar como standby
            
        } else if (_dist <= activation_distance) {
            // ✅ PRÓXIMO DA TELA - SAIR DE STANDBY
            if (variable_instance_exists(id, "standby_mode") && standby_mode) {
                standby_mode = false;
                instance_activate_object(id);
                obj_enemy_standby_manager.units_activated++;
            }
        }
    }
}

// Debug periódico
if (variable_global_exists("debug_enabled") && global.debug_enabled && (timer_check == check_interval)) {
    if (units_in_standby > 0 || units_activated > 0) {
        show_debug_message("📊 Standby: " + string(units_in_standby) + " em standby, " + string(units_activated) + " ativadas");
    }
}

