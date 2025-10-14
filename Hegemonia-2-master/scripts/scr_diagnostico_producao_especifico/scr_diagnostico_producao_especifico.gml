/// @description Diagnóstico específico do sistema de produção naval
/// @function scr_diagnostico_producao_especifico

show_debug_message("=== DIAGNÓSTICO ESPECÍFICO: PRODUÇÃO NAVAL ===");

// 1. Verificar se há quartéis
var quartel_count = instance_number(obj_quartel_marinha);
show_debug_message("🔍 Quartéis encontrados: " + string(quartel_count));

if (quartel_count == 0) {
    show_debug_message("❌ Nenhum quartel encontrado! Criando quartel de teste...");
    var quartel_teste = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel_teste != noone) {
        show_debug_message("✅ Quartel de teste criado: " + string(quartel_teste));
    } else {
        show_debug_message("❌ Falha ao criar quartel!");
        exit;
    }
}

// 2. Verificar cada quartel em detalhes
with (obj_quartel_marinha) {
    show_debug_message("🏭 === QUARTEL ID: " + string(id) + " ===");
    
    // Estado básico
    show_debug_message("📊 Estado básico:");
    show_debug_message("   - Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   - Produzindo: " + string(produzindo));
    show_debug_message("   - Alarm[0]: " + string(alarm[0]));
    show_debug_message("   - Alarm[1]: " + string(alarm[1]));
    show_debug_message("   - Alarm[2]: " + string(alarm[2]));
    
    // Fila de produção
    show_debug_message("📋 Fila de produção:");
    show_debug_message("   - Fila vazia: " + string(ds_queue_empty(fila_producao)));
    show_debug_message("   - Tamanho da fila: " + string(ds_queue_size(fila_producao)));
    
    if (!ds_queue_empty(fila_producao)) {
        var proxima_unidade = ds_queue_head(fila_producao);
        show_debug_message("   - Próxima unidade: " + proxima_unidade.nome);
        show_debug_message("   - Tempo de produção: " + string(proxima_unidade.tempo_treino));
        show_debug_message("   - Objeto: " + string(proxima_unidade.objeto));
    }
    
    // Variáveis críticas
    show_debug_message("🔧 Variáveis críticas:");
    show_debug_message("   - timer_producao: " + string(variable_instance_exists(id, "timer_producao") ? timer_producao : "NÃO EXISTE"));
    show_debug_message("   - unidades_produzidas: " + string(variable_instance_exists(id, "unidades_produzidas") ? unidades_produzidas : "NÃO EXISTE"));
    
    // Verificar se Step Event está executando
    show_debug_message("🔄 Step Event:");
    show_debug_message("   - step_debug_count existe: " + string(variable_instance_exists(id, "step_debug_count")));
    if (variable_instance_exists(id, "step_debug_count")) {
        show_debug_message("   - step_debug_count: " + string(step_debug_count));
    }
    
    // Verificar eventos
    show_debug_message("📋 Eventos:");
    show_debug_message("   - Step Event existe: " + string(event_exists(ev_step, 0)));
    show_debug_message("   - Alarm Event existe: " + string(event_exists(ev_alarm, 0)));
    show_debug_message("   - Mouse Event existe: " + string(event_exists(ev_mouse, 53)));
}

// 3. Verificar recursos globais
show_debug_message("💰 Recursos:");
show_debug_message("   - Dinheiro: $" + string(global.dinheiro));
show_debug_message("   - Minério: " + string(global.minerio));

// 4. Verificar objeto navio
show_debug_message("🚢 Objeto navio:");
show_debug_message("   - obj_lancha_patrulha existe: " + string(object_exists(obj_lancha_patrulha)));
if (object_exists(obj_lancha_patrulha)) {
    var navios_count = instance_number(obj_lancha_patrulha);
    show_debug_message("   - Navios existentes: " + string(navios_count));
    
    // Verificar navios existentes
    with (obj_lancha_patrulha) {
        show_debug_message("   - Navio ID: " + string(id) + " em (" + string(x) + ", " + string(y) + ")");
    }
}

// 5. Teste de criação direta
show_debug_message("🧪 Teste de criação direta:");
var navio_teste = instance_create_layer(500, 500, "rm_mapa_principal", obj_lancha_patrulha);
if (navio_teste != noone) {
    show_debug_message("✅ Criação direta funcionou!");
    show_debug_message("   - ID: " + string(navio_teste));
    show_debug_message("   - Posição: (" + string(navio_teste.x) + ", " + string(navio_teste.y) + ")");
    show_debug_message("   - Variáveis:");
    show_debug_message("     - selecionado: " + string(variable_instance_exists(navio_teste, "selecionado") ? navio_teste.selecionado : "N/A"));
    show_debug_message("     - alcance_tiro: " + string(variable_instance_exists(navio_teste, "alcance_tiro") ? navio_teste.alcance_tiro : "N/A"));
} else {
    show_debug_message("❌ Criação direta falhou!");
}

show_debug_message("=== DIAGNÓSTICO CONCLUÍDO ===");
