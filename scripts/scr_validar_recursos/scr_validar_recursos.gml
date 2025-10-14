/// @description Validar se há recursos suficientes para uma ação
/// @param {real} custo_dinheiro Custo em dinheiro
/// @param {real} custo_minerio Custo em minério
/// @param {real} custo_petroleo Custo em petróleo
/// @param {real} custo_populacao Custo em população
/// @return {bool} true se recursos suficientes

function scr_validar_recursos(custo_dinheiro, custo_minerio, custo_petroleo, custo_populacao) {
    
    var _recursos_suficientes = true;
    var _recursos_faltando = [];
    
    // === VERIFICAÇÃO DE DINHEIRO ===
    if (global.dinheiro < custo_dinheiro) {
        _recursos_suficientes = false;
        _recursos_faltando[array_length(_recursos_faltando)] = "Dinheiro: $" + string(global.dinheiro) + "/$" + string(custo_dinheiro);
    }
    
    // === VERIFICAÇÃO DE MINÉRIO ===
    if (global.minerio < custo_minerio) {
        _recursos_suficientes = false;
        _recursos_faltando[array_length(_recursos_faltando)] = "Minério: " + string(global.minerio) + "/" + string(custo_minerio);
    }
    
    // === VERIFICAÇÃO DE PETRÓLEO ===
    if (global.petroleo < custo_petroleo) {
        _recursos_suficientes = false;
        _recursos_faltando[array_length(_recursos_faltando)] = "Petróleo: " + string(global.petroleo) + "/" + string(custo_petroleo);
    }
    
    // === VERIFICAÇÃO DE POPULAÇÃO ===
    if (global.populacao < custo_populacao) {
        _recursos_suficientes = false;
        _recursos_faltando[array_length(_recursos_faltando)] = "População: " + string(global.populacao) + "/" + string(custo_populacao);
    }
    
    // === RELATÓRIO ===
    if (!_recursos_suficientes) {
        show_debug_message("❌ RECURSOS INSUFICIENTES:");
        for (var i = 0; i < array_length(_recursos_faltando); i++) {
            show_debug_message("   - " + _recursos_faltando[i]);
        }
    } else {
        show_debug_message("✅ Recursos suficientes para a ação");
    }
    
    return _recursos_suficientes;
}
