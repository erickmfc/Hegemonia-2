/// @description Teste específico do Alarm Event
/// @function scr_teste_alarm_event

show_debug_message("=== TESTE: ALARM EVENT ESPECÍFICO ===");

// 1. Encontrar quartel
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("❌ Nenhum quartel encontrado!");
    exit;
}

show_debug_message("🏭 Quartel encontrado: " + string(quartel));

// 2. Verificar estado atual
show_debug_message("📊 Estado atual:");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));

// 3. Limpar estado anterior
quartel.produzindo = false;
quartel.alarm[0] = 0;
ds_queue_clear(quartel.fila_producao);
show_debug_message("🧹 Estado limpo");

// 4. Adicionar unidade à fila manualmente
var unidade_data = quartel.unidades_disponiveis[| 0];
ds_queue_enqueue(quartel.fila_producao, unidade_data);
show_debug_message("📋 Unidade adicionada à fila");

// 5. Verificar dados da unidade
show_debug_message("🔍 Dados da unidade:");
show_debug_message("   - Nome: " + unidade_data.nome);
show_debug_message("   - Objeto: " + string(unidade_data.objeto));
show_debug_message("   - Tipo: " + string(typeof(unidade_data.objeto)));
show_debug_message("   - Tempo: " + string(unidade_data.tempo_treino));
show_debug_message("   - object_exists: " + string(object_exists(unidade_data.objeto)));

// 6. Definir alarm manualmente
quartel.produzindo = true;
quartel.alarm[0] = unidade_data.tempo_treino;

show_debug_message("⏱️ Alarm[0] definido para: " + string(quartel.alarm[0]));
show_debug_message("🔄 Produzindo: " + string(quartel.produzindo));

// 7. Verificar se alarm foi definido
show_debug_message("✅ Verificação:");
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));

// 8. Teste de criação direta
show_debug_message("🧪 Testando criação direta...");
var navio_teste = instance_create_layer(400, 400, "rm_mapa_principal", obj_lancha_patrulha);
if (navio_teste != noone) {
    show_debug_message("✅ Criação direta funcionou!");
    show_debug_message("   - ID: " + string(navio_teste));
    show_debug_message("   - Posição: (" + string(navio_teste.x) + ", " + string(navio_teste.y) + ")");
} else {
    show_debug_message("❌ Criação direta falhou!");
}

show_debug_message("=== TESTE CONCLUÍDO ===");
show_debug_message("💡 Aguarde " + string(unidade_data.tempo_treino) + " frames para ver se o Alarm Event executa!");
