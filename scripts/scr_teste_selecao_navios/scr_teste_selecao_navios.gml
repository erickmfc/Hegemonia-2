/// @description Teste completo do sistema de seleção de navios
/// @function scr_teste_selecao_navios

show_debug_message("=== TESTE: SISTEMA DE SELEÇÃO DE NAVIOS ===");

// 1. Verificar se há navios
var navios = instance_number(obj_lancha_patrulha);
if (navios == 0) {
    show_debug_message("❌ Nenhum navio encontrado! Criando navio de teste...");
    
    // Criar navio de teste
    var navio_teste = instance_create_layer(400, 300, "rm_mapa_principal", obj_lancha_patrulha);
    if (navio_teste != noone) {
        show_debug_message("✅ Navio de teste criado com ID: " + string(navio_teste));
        show_debug_message("   - Posição: (" + string(navio_teste.x) + ", " + string(navio_teste.y) + ")");
        show_debug_message("   - Alcance de tiro: " + string(navio_teste.alcance_tiro));
        show_debug_message("   - Raio de seleção: " + string(navio_teste.raio_selecao));
    } else {
        show_debug_message("❌ Falha ao criar navio de teste!");
        exit;
    }
}

// 2. Testar sistema de seleção
with (obj_lancha_patrulha) {
    show_debug_message("🚢 Testando navio ID: " + string(id));
    show_debug_message("   - Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   - Selecionado: " + string(selecionado));
    show_debug_message("   - Alcance de tiro: " + string(alcance_tiro));
    show_debug_message("   - Estado: " + string(estado));
    
    // Simular seleção
    selecionado = true;
    show_debug_message("✅ Navio selecionado para teste!");
}

// 3. Verificar se obj_controlador_unidades está funcionando
var controlador = instance_first(obj_controlador_unidades);
if (controlador != noone) {
    show_debug_message("🎮 Controlador encontrado: " + string(controlador));
} else {
    show_debug_message("❌ Controlador não encontrado!");
}

// 4. Verificar variáveis do navio
with (obj_lancha_patrulha) {
    show_debug_message("🔍 Verificando variáveis do navio:");
    show_debug_message("   - selecionado: " + string(variable_instance_exists(id, "selecionado") ? selecionado : "NÃO EXISTE"));
    show_debug_message("   - alcance_tiro: " + string(variable_instance_exists(id, "alcance_tiro") ? alcance_tiro : "NÃO EXISTE"));
    show_debug_message("   - raio_selecao: " + string(variable_instance_exists(id, "raio_selecao") ? raio_selecao : "NÃO EXISTE"));
    show_debug_message("   - movendo: " + string(variable_instance_exists(id, "movendo") ? movendo : "NÃO EXISTE"));
}

show_debug_message("=== TESTE CONCLUÍDO ===");
show_debug_message("💡 Agora clique em um navio para testar a seleção!");
show_debug_message("💡 Você deve ver o círculo de alcance de tiro e as cantoneiras azuis!");
