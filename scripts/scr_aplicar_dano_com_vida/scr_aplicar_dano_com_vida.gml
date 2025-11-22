/// @description Aplicar dano a uma unidade e ativar exibição de vida
/// @param {instance} _unidade Unidade que recebeu dano
/// @param {real} _dano Quantidade de dano a aplicar
/// @return true se a unidade foi destruída, false caso contrário

function scr_aplicar_dano_com_vida(_unidade, _dano) {
    if (!instance_exists(_unidade)) {
        return false;
    }
    
    // Verificar se tem sistema de vida
    var _hp_atual = 0;
    var _hp_max = 1;
    var _tem_hp = false;
    
    if (variable_instance_exists(_unidade, "hp_atual") && variable_instance_exists(_unidade, "hp_max")) {
        _hp_atual = _unidade.hp_atual;
        _hp_max = _unidade.hp_max;
        _tem_hp = true;
    } else if (variable_instance_exists(_unidade, "vida") && variable_instance_exists(_unidade, "vida_max")) {
        _hp_atual = _unidade.vida;
        _hp_max = _unidade.vida_max;
        _tem_hp = true;
    } else if (variable_instance_exists(_unidade, "hp") && variable_instance_exists(_unidade, "hp_max")) {
        _hp_atual = _unidade.hp;
        _hp_max = _unidade.hp_max;
        _tem_hp = true;
    }
    
    if (!_tem_hp) {
        return false; // Unidade não tem sistema de vida
    }
    
    // ✅ NOVO: Verificar se é o primeiro dano (hp_atual == hp_max)
    var _primeiro_dano = (_hp_atual >= _hp_max);
    
    // Aplicar dano
    if (variable_instance_exists(_unidade, "hp_atual")) {
        _unidade.hp_atual -= _dano;
        _hp_atual = _unidade.hp_atual;
    } else if (variable_instance_exists(_unidade, "vida")) {
        _unidade.vida -= _dano;
        _hp_atual = _unidade.vida;
    } else if (variable_instance_exists(_unidade, "hp")) {
        _unidade.hp -= _dano;
        _hp_atual = _unidade.hp;
    }
    
    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
    if (_primeiro_dano && _hp_atual < _hp_max) {
        _unidade.mostrar_vida = true;
        _unidade.timer_vida_visivel = 0; // Timer para manter visível
        
        // Calcular porcentagem
        var _porcentagem = round((_hp_atual / _hp_max) * 100);
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("💥 " + object_get_name(_unidade.object_index) + " atingido pela primeira vez! HP: " + string(_hp_atual) + "/" + string(_hp_max) + " (" + string(_porcentagem) + "%)");
        }
    } else if (_hp_atual < _hp_max) {
        // ✅ Continuar mostrando vida se já foi atingida
        if (!variable_instance_exists(_unidade, "mostrar_vida")) {
            _unidade.mostrar_vida = true;
        }
        _unidade.timer_vida_visivel = 0; // Resetar timer
        
        // Atualizar porcentagem
        var _porcentagem = round((_hp_atual / _hp_max) * 100);
    }
    
    // Verificar se foi destruída
    if (_hp_atual <= 0) {
        if (variable_instance_exists(_unidade, "hp_atual")) {
            _unidade.hp_atual = 0;
        } else if (variable_instance_exists(_unidade, "vida")) {
            _unidade.vida = 0;
        } else if (variable_instance_exists(_unidade, "hp")) {
            _unidade.hp = 0;
        }
        
        return true; // Unidade foi destruída
    }
    
    return false; // Unidade ainda está viva
}

