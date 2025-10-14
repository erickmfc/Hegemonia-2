/// @description Criar unidade de forma segura
/// @param {struct} _unidade_data Dados da unidade a ser criada
/// @return {Id.Instance} ID da unidade criada ou noone se falhou

function scr_criar_unidade_segura(_unidade_data) {
    // Verificar se objeto existe e não é noone
    if (_unidade_data.objeto == noone || !object_exists(_unidade_data.objeto)) {
        show_debug_message("❌ Objeto não existe ou é noone: " + string(_unidade_data.objeto));
        return noone;
    }
    
    // Calcular posição de spawn
    var _spawn_x = x + 80 + (unidades_produzidas * 20);
    var _spawn_y = y + 80 + (unidades_produzidas * 15);
    
    // Criar unidade
    var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", _unidade_data.objeto);
    
    if (instance_exists(_unidade_criada)) {
        // Configurar unidade
        _unidade_criada.nacao_proprietaria = nacao_proprietaria;
        unidades_produzidas++;
        
        show_debug_message("✅ " + _unidade_data.nome + " criada em (" + 
                          string(_spawn_x) + ", " + string(_spawn_y) + ")");
        
        return _unidade_criada;
    } else {
        show_debug_message("❌ Falha ao criar unidade: " + _unidade_data.nome);
        return noone;
    }
}