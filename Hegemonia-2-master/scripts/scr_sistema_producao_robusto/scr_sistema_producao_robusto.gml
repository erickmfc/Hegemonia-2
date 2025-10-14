/// @description Sistema de produção naval robusto
/// @function scr_sistema_producao_robusto

show_debug_message("=== SISTEMA DE PRODUÇÃO ROBUSTO ===");

// 1. Encontrar quartel
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("❌ Nenhum quartel encontrado!");
    exit;
}

show_debug_message("🏭 Quartel encontrado: " + string(quartel));

// 2. Verificar se há produção pendente
if (quartel.produzindo && !ds_queue_empty(quartel.fila_producao)) {
    show_debug_message("🎯 Produção pendente detectada!");
    
    var proxima_unidade = ds_queue_head(quartel.fila_producao);
    show_debug_message("📋 Próxima unidade: " + proxima_unidade.nome);
    show_debug_message("⏱️ Tempo de produção: " + string(proxima_unidade.tempo_treino) + " frames");
    show_debug_message("🔍 Alarm[0] atual: " + string(quartel.alarm[0]));
    
    // Se alarm expirou ou está próximo de expirar
    if (quartel.alarm[0] <= 0) {
        show_debug_message("🚨 TEMPO DE PRODUÇÃO CONCLUÍDO!");
        
        // Criar unidade
        var _spawn_x = quartel.x + 80;
        var _spawn_y = quartel.y + 80;
        
        show_debug_message("📍 Criando navio em: (" + string(_spawn_x) + ", " + string(_spawn_y) + ")");
        
        var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
        
        if (instance_exists(_unidade_criada)) {
            quartel.unidades_produzidas++;
            show_debug_message("✅ NAVIO CRIADO COM SUCESSO!");
            show_debug_message("   - ID: " + string(_unidade_criada));
            show_debug_message("   - Posição: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
            show_debug_message("   - Total produzidos: " + string(quartel.unidades_produzidas));
            
            // Configurar navio
            _unidade_criada.nacao_proprietaria = quartel.nacao_proprietaria;
            show_debug_message("   - Nação: " + string(_unidade_criada.nacao_proprietaria));
            
            // Remover da fila
            ds_queue_dequeue(quartel.fila_producao);
            
            // Próxima unidade
            if (!ds_queue_empty(quartel.fila_producao)) {
                var _proxima = ds_queue_head(quartel.fila_producao);
                quartel.alarm[0] = _proxima.tempo_treino;
                show_debug_message("🔄 Iniciando próxima produção...");
                show_debug_message("⏱️ Próximo alarme: " + string(_proxima.tempo_treino) + " frames");
            } else {
                quartel.produzindo = false;
                show_debug_message("🏁 Fila vazia - Quartel ocioso");
            }
            
        } else {
            show_debug_message("❌ FALHA AO CRIAR NAVIO!");
            show_debug_message("🔍 Verificando problemas...");
            
            // Verificar se objeto existe
            show_debug_message("   - obj_lancha_patrulha existe: " + string(object_exists(obj_lancha_patrulha)));
            
            // Tentar criação alternativa
            show_debug_message("🔄 Tentando criação alternativa...");
            var _alt_criada = instance_create_layer(_spawn_x + 50, _spawn_y + 50, "rm_mapa_principal", obj_lancha_patrulha);
            
            if (instance_exists(_alt_criada)) {
                show_debug_message("✅ Criação alternativa funcionou!");
                quartel.unidades_produzidas++;
                _alt_criada.nacao_proprietaria = quartel.nacao_proprietaria;
                ds_queue_dequeue(quartel.fila_producao);
            } else {
                show_debug_message("❌ Criação alternativa também falhou!");
            }
        }
        
    } else {
        show_debug_message("⏱️ Aguardando produção... " + string(quartel.alarm[0]) + " frames restantes");
    }
    
} else {
    show_debug_message("ℹ️ Nenhuma produção pendente");
    show_debug_message("   - Produzindo: " + string(quartel.produzindo));
    show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));
}

show_debug_message("=== SISTEMA ROBUSTO CONCLUÍDO ===");
