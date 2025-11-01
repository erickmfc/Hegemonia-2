/// @description Gerencia ativação/desativação de instâncias baseado na câmera (OTIMIZADO)
/// Sistema completo com LOD dinâmico e gestão de objetos críticos
function scr_manage_instance_lod() {
    var cam = view_camera[0];
    if (cam == noone) return;
    
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    // ✅ Calcular zoom atual para ajustar margem dinamicamente
    var current_zoom = 1.0;
    if (instance_exists(obj_input_manager)) {
        current_zoom = obj_input_manager.zoom_level;
    }
    
    // ✅ Margem adaptativa baseada no zoom (mais margem quando zoom próximo)
    var margin_activation = 800; // Base: 800 pixels
    if (current_zoom >= 2.0) {
        margin_activation = 1200; // Zoom próximo = mais margem (objetos importantes visíveis)
    } else if (current_zoom >= 1.0) {
        margin_activation = 1000; // Zoom médio
    } else if (current_zoom >= 0.6) {
        margin_activation = 800; // Base
    } else {
        margin_activation = 600; // Zoom afastado = menos margem (performance)
    }
    
    var x1 = cam_x - margin_activation;
    var y1 = cam_y - margin_activation;
    var x2 = cam_x + cam_w + margin_activation;
    var y2 = cam_y + cam_h + margin_activation;
    
    // ✅ Desativar todas as instâncias fora da área
    instance_deactivate_region(x1, y1, x2, y2, false);
    
    // ✅ Ativar apenas instâncias dentro da área
    instance_activate_region(x1, y1, x2, y2, false);
    
    // ✅ SEMPRE manter objetos de gerenciamento ativos
    if (object_exists(obj_game_manager)) instance_activate_object(obj_game_manager);
    if (object_exists(obj_input_manager)) instance_activate_object(obj_input_manager);
    if (object_exists(obj_controlador_unidades)) instance_activate_object(obj_controlador_unidades);
    if (object_exists(obj_controlador_construcao)) instance_activate_object(obj_controlador_construcao);
    
    // ✅ Manter unidades selecionadas sempre ativas
    if (variable_global_exists("unidade_selecionada")) {
        var _sel = global.unidade_selecionada;
        if (instance_exists(_sel)) {
            instance_activate_object(_sel);
            // Garantir que unidades selecionadas sejam sempre processadas
            if (!variable_instance_exists(_sel, "force_always_active")) {
                _sel.force_always_active = true;
            }
        }
    }
    
    // ✅ Manter múltiplas unidades selecionadas ativas (se houver sistema de seleção múltipla)
    if (variable_global_exists("unidades_selecionadas") && is_array(global.unidades_selecionadas)) {
        for (var i = 0; i < array_length(global.unidades_selecionadas); i++) {
            var _unit = global.unidades_selecionadas[i];
            if (instance_exists(_unit)) {
                instance_activate_object(_unit);
                if (!variable_instance_exists(_unit, "force_always_active")) {
                    _unit.force_always_active = true;
                }
            }
        }
    }
    
    // ✅ Forçar ativação de instâncias críticas (unidades em combate, estruturas importantes, etc.)
    // Manter unidades em combate sempre ativas para não quebrar sistema de IA
    with (all) {
        if (variable_instance_exists(id, "force_always_active") && force_always_active) {
            instance_activate_object(id);
        }
        // Manter unidades em estado de combate ativas
        if (variable_instance_exists(id, "estado")) {
            if (estado == "atacando" || estado == "movendo" || estado == "recuando") {
                instance_activate_object(id);
            }
        }
    }
}

