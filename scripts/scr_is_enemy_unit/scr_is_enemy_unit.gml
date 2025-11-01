/// @description Verifica se é uma unidade militar inimiga (nacao != 1)
/// @param {Id.Instance} _unit ID da instância
/// @return {bool} true se é unidade inimiga

function scr_is_enemy_unit(_unit) {
    if (!instance_exists(_unit)) {
        return false;
    }
    
    if (!variable_instance_exists(_unit, "nacao_proprietaria")) {
        return false;
    }
    
    return (_unit.nacao_proprietaria != 1);
}

