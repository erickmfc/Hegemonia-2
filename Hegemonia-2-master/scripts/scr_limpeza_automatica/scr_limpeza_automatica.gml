/// @description Limpeza automática de objetos desnecessários
/// @param {real} forcar_limpeza Se deve forçar limpeza

function scr_limpeza_automatica(forcar_limpeza) {
    
    var _objetos_removidos = 0;
    var _memoria_liberada = 0;
    
    // === LIMPEZA DE PROJÉTEIS ANTIGOS ===
    if (object_exists(obj_tiro_infantaria)) {
        with (obj_tiro_infantaria) {
            if (variable_instance_exists(id, "data_criacao") && current_time - data_criacao > 10000) { // 10 segundos
                _objetos_removidos++;
                instance_destroy();
            }
        }
    }
    
    // === LIMPEZA DE EFEITOS FINALIZADOS ===
    if (object_exists(obj_efeito_visual)) {
        with (obj_efeito_visual) {
            if (variable_instance_exists(id, "efeito_finalizado") && efeito_finalizado) {
                _objetos_removidos++;
                instance_destroy();
            }
        }
    }
    
    // === LIMPEZA DE UI INATIVA ===
    if (object_exists(obj_ui_element)) {
        with (obj_ui_element) {
            if (variable_instance_exists(id, "ativo") && !ativo && 
                variable_instance_exists(id, "ultima_atividade") && 
                current_time - ultima_atividade > 30000) { // 30 segundos
                _objetos_removidos++;
                instance_destroy();
            }
        }
    }
    
    // === LIMPEZA DE LISTAS ===
    if (ds_exists(global.lista_temporaria, ds_type_list)) {
        ds_list_destroy(global.lista_temporaria);
        _memoria_liberada++;
    }
    
    // === RELATÓRIO ===
    if (_objetos_removidos > 0 || forcar_limpeza) {
        show_debug_message("🧹 Limpeza automática: " + string(_objetos_removidos) + " objetos removidos, " + string(_memoria_liberada) + " estruturas de dados liberadas");
    }
}