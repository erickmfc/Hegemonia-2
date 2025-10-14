/// @description Script para testar o ataque da lancha
/// @param lancha_x Posição X da lancha
/// @param lancha_y Posição Y da lancha

function scr_teste_lancha_ataque(lancha_x, lancha_y) {
    
    show_debug_message("🧪 === TESTE DE ATAQUE DA LANCHA ===");
    show_debug_message("📍 Posição da lancha: (" + string(lancha_x) + ", " + string(lancha_y) + ")");
    
    // Criar inimigos próximos à lancha para teste
    var _distancia_teste = 200; // 200 pixels de distância
    
    // Criar obj_inimigo próximo
    var _inimigo1 = instance_create(lancha_x + _distancia_teste, lancha_y, obj_inimigo);
    if (instance_exists(_inimigo1)) {
        _inimigo1.nacao_proprietaria = 2; // Nação inimiga
        _inimigo1.hp_atual = 100; // HP para teste
        show_debug_message("✅ Inimigo 1 criado em: (" + string(_inimigo1.x) + ", " + string(_inimigo1.y) + ")");
    }
    
    // Criar obj_infantaria próximo
    var _inimigo2 = instance_create(lancha_x - _distancia_teste, lancha_y, obj_infantaria);
    if (instance_exists(_inimigo2)) {
        _inimigo2.nacao_proprietaria = 2; // Nação inimiga
        _inimigo2.hp_atual = 80; // HP para teste
        show_debug_message("✅ Inimigo 2 (infantaria) criado em: (" + string(_inimigo2.x) + ", " + string(_inimigo2.y) + ")");
    }
    
    // Criar obj_tanque próximo
    var _inimigo3 = instance_create(lancha_x, lancha_y + _distancia_teste, obj_tanque);
    if (instance_exists(_inimigo3)) {
        _inimigo3.nacao_proprietaria = 2; // Nação inimiga
        _inimigo3.hp_atual = 150; // HP para teste
        show_debug_message("✅ Inimigo 3 (tanque) criado em: (" + string(_inimigo3.x) + ", " + string(_inimigo3.y) + ")");
    }
    
    show_debug_message("🎯 Inimigos criados para teste! A lancha deve atacar em 1 segundo.");
    show_debug_message("📊 Total de inimigos na sala:");
    show_debug_message("   - obj_inimigo: " + string(instance_number(obj_inimigo)));
    show_debug_message("   - obj_infantaria: " + string(instance_number(obj_infantaria)));
    show_debug_message("   - obj_tanque: " + string(instance_number(obj_tanque)));
}
