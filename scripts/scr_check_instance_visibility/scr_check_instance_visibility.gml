/// @description Verifica se instância está dentro da área visível da câmera
/// @param {any} inst_id ID da instância
/// @param {real} margin Margem extra (pixels) além da viewport
/// @return {bool} true se visível
function scr_check_instance_visibility(inst_id, margin = 0) {
    
    if (!instance_exists(inst_id)) {
        return false;
    }
    
    var cam = view_camera[0];
    if (cam == noone) {
        return true; // Sem câmera = sempre visível (fallback)
    }
    
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    var inst_x = inst_id.x;
    var inst_y = inst_id.y;
    
    // Verificar se está dentro (com margem)
    return (inst_x >= cam_x - margin && inst_x <= cam_x + cam_w + margin &&
            inst_y >= cam_y - margin && inst_y <= cam_y + cam_h + margin);
}

/// @description Força instância a sempre permanecer ativa (ex: selecionada)
/// @param {any} inst_id ID da instância
function scr_force_instance_always_active(inst_id) {
    if (instance_exists(inst_id)) {
        if (!variable_instance_exists(inst_id, "force_always_active")) {
            inst_id.force_always_active = false;
        }
        inst_id.force_always_active = true;
        instance_activate_object(inst_id);
    }
}

/// @description Remove flag de sempre ativo de uma instância
/// @param {any} inst_id ID da instância
function scr_remove_force_always_active(inst_id) {
    if (instance_exists(inst_id)) {
        inst_id.force_always_active = false;
    }
}
