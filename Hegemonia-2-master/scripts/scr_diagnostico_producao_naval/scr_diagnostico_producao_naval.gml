/// @description Diagnóstico completo do sistema de produção naval
/// @function scr_diagnostico_producao_naval

show_debug_message("=== DIAGNÓSTICO: SISTEMA DE PRODUÇÃO NAVAL ===");

// 1. Verificar se há quartéis de marinha
var quartel_count = instance_number(obj_quartel_marinha);
show_debug_message("🔍 Quartéis de marinha encontrados: " + string(quartel_count));

if (quartel_count == 0) {
    show_debug_message("❌ Nenhum quartel de marinha encontrado!");
    show_debug_message("💡 Criando quartel de teste...");
    
    var quartel_teste = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel_teste != noone) {
        show_debug_message("✅ Quartel de teste criado: " + string(quartel_teste));
    } else {
        show_debug_message("❌ Falha ao criar quartel de teste!");
        exit;
    }
}

// 2. Verificar cada quartel
with (obj_quartel_marinha) {
    show_debug_message("🏭 === QUARTEL ID: " + string(id) + " ===");
    show_debug_message("   - Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   - Produzindo: " + string(produzindo));
    show_debug_message("   - Fila vazia: " + string(ds_queue_empty(fila_producao)));
    show_debug_message("   - Tamanho da fila: " + string(ds_queue_size(fila_producao)));
    show_debug_message("   - Alarm[0]: " + string(alarm[0]));
    show_debug_message("   - Unidades produzidas: " + string(unidades_produzidas));
    
    // Verificar variáveis críticas
    show_debug_message("   - Variável 'produzindo' existe: " + string(variable_instance_exists(id, "produzindo")));
    show_debug_message("   - Variável 'fila_producao' existe: " + string(variable_instance_exists(id, "fila_producao")));
    show_debug_message("   - Variável 'timer_producao' existe: " + string(variable_instance_exists(id, "timer_producao")));
    
    // Verificar se fila tem conteúdo
    if (!ds_queue_empty(fila_producao)) {
        var proxima_unidade = ds_queue_head(fila_producao);
        show_debug_message("   - Próxima unidade: " + proxima_unidade.nome);
        show_debug_message("   - Tempo de produção: " + string(proxima_unidade.tempo_treino));
        show_debug_message("   - Objeto: " + string(proxima_unidade.objeto));
    }
}

// 3. Verificar recursos globais
show_debug_message("💰 Recursos globais:");
show_debug_message("   - Dinheiro: $" + string(global.dinheiro));
show_debug_message("   - Minério: " + string(global.minerio));

// 4. Verificar se obj_lancha_patrulha existe
show_debug_message("🚢 Verificando objeto navio:");
show_debug_message("   - obj_lancha_patrulha existe: " + string(object_exists(obj_lancha_patrulha)));
if (object_exists(obj_lancha_patrulha)) {
    var navios_count = instance_number(obj_lancha_patrulha);
    show_debug_message("   - Navios existentes: " + string(navios_count));
}

// 5. Teste de criação direta
show_debug_message("🧪 Testando criação direta de navio...");
var navio_teste = instance_create_layer(300, 300, "rm_mapa_principal", obj_lancha_patrulha);
if (navio_teste != noone) {
    show_debug_message("✅ Criação direta funcionou! ID: " + string(navio_teste));
    show_debug_message("   - Posição: (" + string(navio_teste.x) + ", " + string(navio_teste.y) + ")");
    show_debug_message("   - Variáveis do navio:");
    show_debug_message("     - selecionado: " + string(variable_instance_exists(navio_teste, "selecionado") ? navio_teste.selecionado : "N/A"));
    show_debug_message("     - alcance_tiro: " + string(variable_instance_exists(navio_teste, "alcance_tiro") ? navio_teste.alcance_tiro : "N/A"));
} else {
    show_debug_message("❌ Criação direta falhou!");
}

// 6. Verificar eventos do quartel
show_debug_message("📋 Eventos do quartel:");
var quartel = instance_first(obj_quartel_marinha);
if (quartel != noone) {
    show_debug_message("   - Step Event existe: " + string(event_exists(ev_step, 0)));
    show_debug_message("   - Alarm Event existe: " + string(event_exists(ev_alarm, 0)));
    show_debug_message("   - Mouse Event existe: " + string(event_exists(ev_mouse, 53)));
}

show_debug_message("=== DIAGNÓSTICO CONCLUÍDO ===");
show_debug_message("💡 Próximos passos:");
show_debug_message("   1. Verificar se Alarm[0] está sendo definido corretamente");
show_debug_message("   2. Verificar se Alarm Event está executando");
show_debug_message("   3. Verificar se há conflitos entre eventos");
