/// @description Verifica se é uma unidade militar inimiga
/// @param {Id.Instance} _unit ID da instância
/// @param {real} _minha_nacao Nação atual (opcional, padrão: 1)
/// @return {bool} true se é unidade inimiga

function scr_is_enemy_unit(_unit, _minha_nacao = 1) {
    if (!instance_exists(_unit)) {
        return false;
    }
    
    if (!variable_instance_exists(_unit, "nacao_proprietaria")) {
        return false;
    }
    
    // ✅ CORREÇÃO: Piratas (nação 3) são inimigos de TODAS as outras nações
    var _nacao_unidade = _unit.nacao_proprietaria;
    
    if (_nacao_unidade == 3) {
        // Piratas são inimigos de todos (exceto outros piratas)
        return (_minha_nacao != 3);
    } else if (_minha_nacao == 3) {
        // Se sou pirata, todos os outros são inimigos
        return (_nacao_unidade != 3);
    } else {
        // Lógica normal: inimigo se nação diferente
        return (_nacao_unidade != _minha_nacao);
    }
}

