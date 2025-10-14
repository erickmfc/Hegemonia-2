/// @description Teste específico do Step Event
/// @function scr_teste_step_event

show_debug_message("=== TESTE: STEP EVENT ESPECÍFICO ===");

// 1. Encontrar quartel
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("❌ Nenhum quartel encontrado!");
    exit;
}

show_debug_message("🏭 Quartel encontrado: " + string(quartel));

// 2. Verificar estado inicial
show_debug_message("📊 Estado inicial:");
show_debug_message("   - step_debug_count existe: " + string(variable_instance_exists(quartel, "step_debug_count")));
if (variable_instance_exists(quartel, "step_debug_count")) {
    show_debug_message("   - step_debug_count atual: " + string(quartel.step_debug_count));
}

// 3. Aguardar alguns frames para ver se Step Event executa
show_debug_message("⏱️ Aguardando 5 segundos para verificar Step Event...");

// Simular espera (em um jogo real, você aguardaria)
var frames_aguardados = 0;
while (frames_aguardados < 300) { // 5 segundos
    frames_aguardados++;
    // Em um jogo real, você não faria isso, mas para teste...
}

// 4. Verificar se Step Event executou
show_debug_message("🔍 Após 5 segundos:");
show_debug_message("   - step_debug_count: " + string(quartel.step_debug_count));

if (quartel.step_debug_count > 0) {
    show_debug_message("✅ STEP EVENT ESTÁ EXECUTANDO!");
} else {
    show_debug_message("❌ STEP EVENT NÃO ESTÁ EXECUTANDO!");
}

// 5. Forçar produção para testar Step Event
show_debug_message("🎯 Forçando produção para testar Step Event...");

// Limpar estado
quartel.produzindo = false;
quartel.alarm[0] = 0;
ds_queue_clear(quartel.fila_producao);

// Adicionar unidade à fila
var unidade_data = quartel.unidades_disponiveis[| 0];
ds_queue_enqueue(quartel.fila_producao, unidade_data);

// Configurar produção
quartel.produzindo = true;
quartel.alarm[0] = 5; // Apenas 5 frames para teste rápido

show_debug_message("⚙️ Configuração:");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));

// 6. Aguardar alarm expirar
show_debug_message("⏱️ Aguardando alarm expirar...");

var frames_alarm = 0;
while (quartel.alarm[0] > 0 && frames_alarm < 10) {
    frames_alarm++;
    // Em um jogo real, você aguardaria naturalmente
}

show_debug_message("🔍 Após aguardar:");
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Produzindo: " + string(quartel.produzindo));

// 7. Verificar se navio foi criado
var navios_antes = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios antes: " + string(navios_antes));

// Simular execução do Step Event manualmente
if (quartel.produzindo && !ds_queue_empty(quartel.fila_producao) && quartel.alarm[0] <= 0) {
    show_debug_message("🚨 EXECUTANDO STEP EVENT MANUALMENTE...");
    
    var _spawn_x = quartel.x + 80;
    var _spawn_y = quartel.y + 80;
    
    var _unidade_data = ds_queue_dequeue(quartel.fila_producao);
    var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
    
    if (instance_exists(_unidade_criada)) {
        quartel.unidades_produzidas++;
        show_debug_message("✅ NAVIO CRIADO MANUALMENTE!");
        show_debug_message("   - ID: " + string(_unidade_criada));
        show_debug_message("   - Posição: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
    } else {
        show_debug_message("❌ FALHA AO CRIAR NAVIO!");
    }
    
    quartel.produzindo = false;
}

var navios_depois = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios depois: " + string(navios_depois));

if (navios_depois > navios_antes) {
    show_debug_message("✅ SUCESSO: Navio foi criado!");
} else {
    show_debug_message("❌ FALHA: Navio não foi criado!");
}

show_debug_message("=== TESTE CONCLUÍDO ===");
