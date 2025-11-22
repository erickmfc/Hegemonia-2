/// @description Obter índice válido de unidade da fila (suporta número ou estrutura)
/// @param _item_fila Item da fila (pode ser número ou estrutura)
/// @param _unidades_disponiveis Lista de unidades disponíveis
/// @return Índice válido ou -1 se não encontrado
function scr_obter_indice_unidade_valido(_item_fila, _unidades_disponiveis) {
    // ✅ Verificar se é um número (índice válido)
    if (is_real(_item_fila) || is_int32(_item_fila)) {
        // Verificar se o índice está dentro dos limites
        if (ds_exists(_unidades_disponiveis, ds_type_list)) {
            if (_item_fila >= 0 && _item_fila < ds_list_size(_unidades_disponiveis)) {
                return _item_fila;
            }
        }
        return -1; // Índice fora dos limites
    }
    
    // ✅ Se for uma estrutura, procurar na lista
    if (is_struct(_item_fila)) {
        if (ds_exists(_unidades_disponiveis, ds_type_list)) {
            for (var _i = 0; _i < ds_list_size(_unidades_disponiveis); _i++) {
                var _data = ds_list_find_value(_unidades_disponiveis, _i);
                if (is_struct(_data)) {
                    // Comparar objetos para ver se é a mesma estrutura
                    if (variable_struct_exists(_data, "objeto") && variable_struct_exists(_item_fila, "objeto")) {
                        if (_data.objeto == _item_fila.objeto) {
                            return _i;
                        }
                    }
                }
            }
        }
        return -1; // Estrutura não encontrada na lista
    }
    
    // Tipo desconhecido
    return -1;
}

