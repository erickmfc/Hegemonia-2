// ===============================================
// HEGEMONIA GLOBAL - LIMPEZA AUTOMÁTICA OTIMIZADA
// Sistema de Limpeza de Memória Eficiente
// ===============================================

/// @description Limpeza automática otimizada
/// @param {bool} forcar_limpeza Forçar limpeza imediata
function scr_limpeza_automatica_otimizada(forcar_limpeza) {
    var _objetos_removidos = 0;
    var _memoria_liberada = 0;
    
    // === LIMPEZA 1: PROJÉTEIS ANTIGOS ===
    if (object_exists(obj_tiro_infantaria)) {
        with (obj_tiro_infantaria) {
            if (current_time - data_criacao > 10000) { // 10 segundos
                _objetos_removidos++;
                instance_destroy();
            }
        }
    }
    
    // === LIMPEZA 2: EFEITOS VISUAIS FINALIZADOS ===
    if (object_exists(obj_explosao)) {
        with (obj_explosao) {
            if (current_time - data_criacao > 5000) { // 5 segundos
                _objetos_removidos++;
                instance_destroy();
            }
        }
    }
    
    // === LIMPEZA 3: ELEMENTOS UI INATIVOS ===
    if (object_exists(obj_menu_recrutamento_marinha)) {
        with (obj_menu_recrutamento_marinha) {
            if (current_time - data_criacao > 30000) { // 30 segundos
                _objetos_removidos++;
                instance_destroy();
            }
        }
    }
    
    // === LIMPEZA 4: ESTRUTURAS DE DADOS TEMPORÁRIAS ===
    if (ds_exists(global.temp_data, ds_type_map)) {
        if (ds_map_size(global.temp_data) > 100) {
            ds_map_clear(global.temp_data);
            _memoria_liberada += 100;
        }
    }
    
    // === LIMPEZA 5: LISTAS TEMPORÁRIAS ===
    if (ds_exists(global.temp_list, ds_type_list)) {
        if (ds_list_size(global.temp_list) > 50) {
            ds_list_clear(global.temp_list);
            _memoria_liberada += 50;
        }
    }
    
    // === ATUALIZAR ESTATÍSTICAS ===
    if (instance_exists(obj_performance_manager)) {
        obj_performance_manager.objetos_destruidos += _objetos_removidos;
        obj_performance_manager.memoria_liberada += _memoria_liberada;
    }
    
    // Debug apenas se forçar limpeza
    if (forcar_limpeza && (_objetos_removidos > 0 || _memoria_liberada > 0)) {
        show_debug_message("Limpeza: " + string(_objetos_removidos) + " objetos removidos, " + string(_memoria_liberada) + " itens de memória liberados");
    }
}
