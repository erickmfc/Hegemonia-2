// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Produção Naval - STEP EVENT ATIVO
// ===============================================

// ✅ STEP EVENT OTIMIZADO - Debug reduzido
// Debug apenas quando necessário (a cada 10 segundos)
if (!variable_instance_exists(id, "step_debug_count")) {
    step_debug_count = 0;
}
step_debug_count++;
if (step_debug_count % 600 == 0) { // A cada 10 segundos (reduzido)
    show_debug_message("🔄 Quartel Marinha ID: " + string(id) + " - Produzindo: " + string(produzindo) + " | Fila: " + string(ds_queue_size(fila_producao)));
}

// ✅ SISTEMA DE PRODUÇÃO NO STEP EVENT (PRINCIPAL)
// Sistema robusto que funciona independente do Alarm Event
if (produzindo && !ds_queue_empty(fila_producao)) {
    // Sistema de timer alternativo
    if (!variable_instance_exists(id, "timer_producao_step")) {
        timer_producao_step = 0;
    }
    
    // Incrementar timer
    timer_producao_step++;
    
    // Obter dados da unidade
    var _unidade_data = ds_queue_head(fila_producao);
    var _tempo_necessario = _unidade_data.tempo_treino;
    
    // Debug do progresso
    if (step_debug_count % 60 == 0) { // A cada segundo
        show_debug_message("⏱️ STEP EVENT: Progresso - " + string(timer_producao_step) + "/" + string(_tempo_necessario) + " frames");
        show_debug_message("   - Alarm[0]: " + string(alarm[0]));
    }
    
    // Verificar se tempo de produção concluído (usar timer alternativo OU alarm)
    if (timer_producao_step >= _tempo_necessario || alarm[0] <= 0) {
        show_debug_message("🚨 STEP EVENT: Tempo de produção concluído!");
        
        // Criar unidade naval
        var _spawn_x = x + 80;
        var _spawn_y = y + 80;
        
        var _unidade_data = ds_queue_dequeue(fila_producao);
        
        show_debug_message("🚢 STEP EVENT: Criando unidade: " + _unidade_data.nome);
        show_debug_message("📍 Posição de spawn: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
        
        // Tentar criar unidade diretamente
        var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
        
        show_debug_message("🔍 Resultado da criação: " + string(_unidade_criada));
        
        if (instance_exists(_unidade_criada)) {
            unidades_produzidas++;
            show_debug_message("✅ STEP EVENT: Unidade naval criada! ID: " + string(_unidade_criada));
            show_debug_message("📍 Posição final: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
            show_debug_message("🏴 Nação atribuída: " + string(_unidade_criada.nacao_proprietaria));
        } else {
            show_debug_message("❌ STEP EVENT: Falha ao criar unidade!");
        }
        
        // Próxima unidade da fila
        if (!ds_queue_empty(fila_producao)) {
            var _proxima_unidade = ds_queue_head(fila_producao);
            alarm[0] = _proxima_unidade.tempo_treino;
            timer_producao_step = 0; // Reset timer alternativo
            show_debug_message("🔄 STEP EVENT: Iniciando próxima produção...");
            show_debug_message("⏱️ Próximo alarme em: " + string(_proxima_unidade.tempo_treino) + " frames");
            show_debug_message("🔄 Timer alternativo resetado");
        } else {
            produzindo = false;
            timer_producao_step = 0; // Reset timer
            show_debug_message("🏁 STEP EVENT: Fila vazia - Quartel ocioso.");
        }
    }
}