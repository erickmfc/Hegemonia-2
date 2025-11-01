/// @description Verifica se unidade está em patrulha (não deve entrar em standby)
/// @param {Id.Instance} _unit ID da instância
/// @return {bool} true se está patrulhando

function scr_is_unit_in_patrol(_unit) {
    if (!instance_exists(_unit)) return false;
    
    // Verificar estados de patrulha
    if (variable_instance_exists(_unit, "patrulhando") && _unit.patrulhando) {
        return true;
    }
    
    if (variable_instance_exists(_unit, "estado")) {
        var _estado = _unit.estado;
        if (_estado == "patrulhando" || _estado == "definindo_patrulha") {
            return true;
        }
    }
    
    // Verificar se tem pontos de patrulha ativos
    if (variable_instance_exists(_unit, "pontos_patrulha")) {
        if (ds_exists(_unit.pontos_patrulha, ds_type_list)) {
            if (ds_list_size(_unit.pontos_patrulha) > 0) {
                return true;
            }
        }
    }
    
    // Verificar patrulha em unidades de infantaria
    if (variable_instance_exists(_unit, "patrulha")) {
        if (ds_exists(_unit.patrulha, ds_type_list)) {
            if (ds_list_size(_unit.patrulha) > 0) {
                if (variable_instance_exists(_unit, "modo_patrulha") && _unit.modo_patrulha) {
                    return true;
                }
            }
        }
    }
    
    return false;
}
