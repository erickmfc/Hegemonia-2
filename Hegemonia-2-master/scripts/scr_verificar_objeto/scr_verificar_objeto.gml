/// @description Verificar se um objeto está configurado corretamente
/// @param {real} obj_id ID do objeto a verificar
/// @return {bool} true se válido, false se inválido

function scr_verificar_objeto(obj_id) {
    
    var _erros = [];
    var _avisos = [];
    
    // === VERIFICAÇÕES BÁSICAS ===
    if (!instance_exists(obj_id)) {
        _erros[array_length(_erros)] = "Objeto não existe";
        return false;
    }
    
    // === VERIFICAÇÕES DE VARIÁVEIS OBRIGATÓRIAS ===
    var _variaveis_obrigatorias = [
        "x", "y", "hp_atual", "hp_max", "nacao_proprietaria"
    ];
    
    for (var i = 0; i < array_length(_variaveis_obrigatorias); i++) {
        if (!variable_instance_exists(obj_id, _variaveis_obrigatorias[i])) {
            _erros[array_length(_erros)] = "Variável obrigatória ausente: " + _variaveis_obrigatorias[i];
        }
    }
    
    // === VERIFICAÇÕES DE VALORES VÁLIDOS ===
    if (variable_instance_exists(obj_id, "hp_atual")) {
        if (obj_id.hp_atual < 0) {
            _erros[array_length(_erros)] = "HP atual negativo";
        }
        if (obj_id.hp_atual > obj_id.hp_max) {
            _avisos[array_length(_avisos)] = "HP atual maior que máximo";
        }
    }
    
    if (variable_instance_exists(obj_id, "nacao_proprietaria")) {
        if (obj_id.nacao_proprietaria < 1 || obj_id.nacao_proprietaria > 10) {
            _avisos[array_length(_avisos)] = "Nação proprietária inválida";
        }
    }
    
    // === VERIFICAÇÕES DE SPRITE ===
    if (obj_id.sprite_index == noone) {
        _avisos[array_length(_avisos)] = "Objeto sem sprite";
    }
    
    // === VERIFICAÇÕES DE POSIÇÃO ===
    if (obj_id.x < 0 || obj_id.y < 0) {
        _avisos[array_length(_avisos)] = "Posição inválida";
    }
    
    // === RELATÓRIO DE VERIFICAÇÃO ===
    if (array_length(_erros) > 0) {
        show_debug_message("❌ ERROS encontrados no objeto " + string(obj_id) + ":");
        for (var i = 0; i < array_length(_erros); i++) {
            show_debug_message("   - " + _erros[i]);
        }
        return false;
    }
    
    if (array_length(_avisos) > 0) {
        show_debug_message("⚠️ AVISOS para o objeto " + string(obj_id) + ":");
        for (var i = 0; i < array_length(_avisos); i++) {
            show_debug_message("   - " + _avisos[i]);
        }
    }
    
    show_debug_message("✅ Objeto " + string(obj_id) + " verificado com sucesso");
    return true;
}
