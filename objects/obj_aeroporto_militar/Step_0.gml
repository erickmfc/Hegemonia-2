// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Sistema de Produção Aérea - STEP EVENT
// ===============================================

// === SISTEMA DE VIDA ===
// Verificar se HP chegou a 0 e destruir
if (destrutivel && hp_atual <= 0) {
    show_debug_message("💥 Aeroporto destruído - HP: " + string(hp_atual) + "/" + string(hp_max));
    instance_destroy();
    exit;
}

// === SISTEMA DE PRODUÇÃO AÉREA COM FILA ===

// ✅ CORREÇÃO CRÍTICA: NÃO iniciar produção automaticamente
// O aeroporto só deve produzir quando o jogador explicitamente adicionar unidades via menu
// NÃO iniciar automaticamente mesmo que haja unidades na fila - aguardar ação do jogador

if (produzindo && !ds_queue_empty(fila_producao)) {
    
    // Incrementar timer
    timer_producao++;
    
    // Obter dados da unidade atual
    var _unidade_data = ds_queue_head(fila_producao);
    var _tempo_necessario = _unidade_data.tempo_treino;
    
    // Debug a cada segundo
    if (timer_producao % 60 == 0) {
        var _fila_size = ds_queue_size(fila_producao);
        show_debug_message("⏱️ Produção: " + string(timer_producao) + "/" + string(_tempo_necessario) + " frames | Fila: " + string(_fila_size));
    }
    
    // Verificar se produção concluída
    if (timer_producao >= _tempo_necessario) {
        
        // Posição de spawn (mais à direita do aeroporto - área de estacionamento)
        // ✅ MELHORADO: Variação aleatória maior para distribuição
        var _variacao_x = random_range(-40, 40);  // Variação horizontal maior
        var _variacao_y = random_range(-30, 30);  // Variação vertical maior
        
        var _spawn_x = x + 220 + _variacao_x; // Mais à direita com maior espaçamento
        var _spawn_y = y + _variacao_y;       // Mesma altura do aeroporto (não abaixo)
        
        // Remover unidade da fila
        var _unidade_data_final = ds_queue_dequeue(fila_producao);
        
        show_debug_message("✈️ Criando: " + _unidade_data_final.nome);
        show_debug_message("📍 Posição de spawn: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
        show_debug_message("📍 Posição do aeroporto: (" + string(x) + ", " + string(y) + ")");
        show_debug_message("🛫 Decolando da área de estacionamento!");
        
        // Criar unidade aérea
        var _unidade_criada = noone;
        
        if (_unidade_data_final.objeto == obj_caca_f5) {
            _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_caca_f5);
        } else if (_unidade_data_final.objeto == obj_f15) {
            _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_f15);
        } else if (_unidade_data_final.objeto == obj_helicoptero_militar) {
            _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_helicoptero_militar);
        } else if (_unidade_data_final.objeto == obj_c100) {
            _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_c100);
        }
        
        // Verificar se criação foi bem-sucedida
        if (instance_exists(_unidade_criada)) {
            unidades_produzidas++;
            _unidade_criada.nacao_proprietaria = nacao_proprietaria;
            show_debug_message("✅ " + _unidade_data_final.nome + " criado! ID: " + string(_unidade_criada));
        } else {
            show_debug_message("❌ ERRO: Falha ao criar unidade aérea!");
        }
        
        // Próxima unidade ou parar produção
        if (!ds_queue_empty(fila_producao)) {
            timer_producao = 0; // Reset para próxima unidade
            show_debug_message("🔄 Iniciando próxima produção aérea...");
        } else {
            produzindo = false;
            timer_producao = 0;
            show_debug_message("🏁 Produção aérea concluída - Aeroporto ocioso");
        }
    }
}