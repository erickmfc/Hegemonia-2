// =============================================
// SISTEMA DE DEACTIVATION OTIMIZADO
// Gerencia ativação/desativação de instâncias
// =============================================

// === CONFIGURAÇÕES ===
check_interval = 30;          // Verificar a cada 30 frames (0.5s a 60fps)
margin_padding = 500;         // Margem extra além da viewport (px)
activation_distance = 1000;   // Distância para ativar instâncias (px)
lod_threshold_near = 0.8;     // Zoom para considerar "próximo"
lod_threshold_far = 0.5;      // Zoom para considerar "longe"

// === OBJETOS QUE SERÃO GERENCIADOS ===
// ✅ CORREÇÃO: Usar asset_get_index() para buscar objetos de forma segura
managed_objects = [];

// Função auxiliar para adicionar objeto de forma segura
// ✅ CORREÇÃO GM1041: Verificar tipo correto de asset
function _add_managed_object(obj_name) {
    var _asset_id = asset_get_index(obj_name);
    if (_asset_id >= 0) {
        // ✅ CORREÇÃO GM1041: Verificar se é um objeto válido
        // Verificar tipo do asset e se o objeto existe
        if (asset_get_type(_asset_id) == asset_object && object_exists(_asset_id)) {
            // Adicionar ao array (é um objeto válido)
            var _obj_id = _asset_id;
            array_push(managed_objects, _obj_id);
            return true;
        }
    }
    return false;
}

// Adicionar apenas objetos que existem (usando nomes como strings)
// Objetos básicos (sempre devem existir)
_add_managed_object("obj_infantaria");
_add_managed_object("obj_tanque");
_add_managed_object("obj_f15");
_add_managed_object("obj_helicoptero_militar");
_add_managed_object("obj_lancha_patrulha");

// Objetos navais (podem não existir)
_add_managed_object("obj_fragata");
_add_managed_object("obj_navio_base");
_add_managed_object("obj_submarino_base");
_add_managed_object("obj_navio_transporte");
_add_managed_object("obj_destroyer");
_add_managed_object("obj_submarino");

// === ESTATÍSTICAS ===
stats_activated = 0;
stats_deactivated = 0;
stats_check_count = 0;

// === TIMERS ===
timer_check = 0;
current_camera = noone;
cam_x = 0;
cam_y = 0;
cam_w = 0;
cam_h = 0;

// === SISTEMA ATIVO ===
system_enabled = true;

// Debug
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    show_debug_message("✅ Sistema de Deactivation Manager ativado");
    show_debug_message("📋 Objetos gerenciados: " + string(array_length(managed_objects)));
}
