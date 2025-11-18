/// @function scr_verificar_destruicao_estruturas()
/// @description Verifica todas as estruturas e destrói aquelas com HP <= 0
/// @description Deve ser chamado periodicamente (ex: no Step do game_manager)
/// @return {number} Número de estruturas destruídas

function scr_verificar_destruicao_estruturas() {
    
    var _estruturas_destruidas = 0;
    
    // === LISTA DE ESTRUTURAS PARA VERIFICAR ===
    var _tipos_estruturas = [
        obj_fazenda,
        obj_quartel,
        obj_quartel_marinha,
        obj_aeroporto_militar,
        obj_mina,
        obj_banco,
        obj_casa
    ];
    
    // Adicionar outras estruturas se existirem
    var _obj_casa_moeda = asset_get_index("obj_casa_da_moeda");
    if (_obj_casa_moeda != -1 && object_exists(_obj_casa_moeda)) {
        array_push(_tipos_estruturas, _obj_casa_moeda);
    }
    
    // === VERIFICAR CADA TIPO DE ESTRUTURA ===
    for (var i = 0; i < array_length(_tipos_estruturas); i++) {
        var _tipo_estrutura = _tipos_estruturas[i];
        if (!object_exists(_tipo_estrutura)) continue;
        
        with (_tipo_estrutura) {
            // Verificar se é destrutível e tem HP
            var _deve_destruir = false;
            
            if (variable_instance_exists(id, "destrutivel") && destrutivel) {
                if (variable_instance_exists(id, "hp_atual") && hp_atual <= 0) {
                    _deve_destruir = true;
                } else if (variable_instance_exists(id, "vida") && vida <= 0) {
                    _deve_destruir = true;
                }
            }
            
            // Se deve destruir, chamar função de destruição
            if (_deve_destruir) {
                var _nome = object_get_name(object_index);
                show_debug_message("💥 Estrutura " + _nome + " com HP <= 0 detectada - iniciando destruição");
                
                if (scr_destruir_estrutura(id)) {
                    other._estruturas_destruidas++;
                }
            }
        }
    }
    
    if (_estruturas_destruidas > 0) {
        show_debug_message("💥 Total de estruturas destruídas neste ciclo: " + string(_estruturas_destruidas));
    }
    
    return _estruturas_destruidas;
}

