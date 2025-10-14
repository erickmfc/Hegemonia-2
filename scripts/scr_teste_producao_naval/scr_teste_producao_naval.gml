/// @description Teste de produção naval simulada
/// @function scr_teste_producao_naval

show_debug_message("=== TESTE: PRODUÇÃO NAVAL SIMULADA ===");

// 1. Encontrar quartel
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("❌ Nenhum quartel encontrado! Criando...");
    quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel == noone) {
        show_debug_message("❌ Falha ao criar quartel!");
        exit;
    }
}

show_debug_message("🏭 Usando quartel: " + string(quartel));

// 2. Verificar estado inicial
show_debug_message("📊 Estado inicial:");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));

// 3. Simular clique no botão produzir
show_debug_message("🎯 Simulando clique no botão produzir...");

// Verificar recursos
if (global.dinheiro >= 50) {
    show_debug_message("💰 Recursos suficientes: $" + string(global.dinheiro));
    
    // Deduzir recursos
    global.dinheiro -= 50;
    show_debug_message("💵 Dinheiro após dedução: $" + string(global.dinheiro));
    
    // Obter dados da unidade
    var unidade_data = quartel.unidades_disponiveis[| 0];
    show_debug_message("🚢 Unidade: " + unidade_data.nome);
    show_debug_message("⏱️ Tempo: " + string(unidade_data.tempo_treino) + " frames");
    
    // Adicionar à fila
    ds_queue_enqueue(quartel.fila_producao, unidade_data);
    show_debug_message("📋 Unidade adicionada à fila. Tamanho: " + string(ds_queue_size(quartel.fila_producao)));
    
    // Iniciar produção
    if (!quartel.produzindo) {
        quartel.produzindo = true;
        quartel.alarm[0] = unidade_data.tempo_treino;
        
        show_debug_message("🚀 Produção iniciada!");
        show_debug_message("⏱️ Alarm[0] definido para: " + string(quartel.alarm[0]) + " frames");
        show_debug_message("🔄 Produzindo: " + string(quartel.produzindo));
        
        // Verificar se alarm foi definido corretamente
        show_debug_message("✅ Verificação pós-definição:");
        show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
        show_debug_message("   - Produzindo: " + string(quartel.produzindo));
        show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));
        
    } else {
        show_debug_message("ℹ️ Quartel já estava produzindo");
    }
    
} else {
    show_debug_message("❌ Recursos insuficientes! Precisa: $50, Tem: $" + string(global.dinheiro));
}

show_debug_message("=== TESTE CONCLUÍDO ===");
show_debug_message("💡 Aguarde " + string(unidade_data.tempo_treino) + " frames para ver se o navio é criado!");
