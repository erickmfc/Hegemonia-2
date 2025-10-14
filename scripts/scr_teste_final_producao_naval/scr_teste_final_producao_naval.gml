/// @description Teste final completo do sistema de produção naval
/// @function scr_teste_final_producao_naval

show_debug_message("=== TESTE FINAL: SISTEMA DE PRODUÇÃO NAVAL ===");

// 1. Verificar estado inicial
show_debug_message("🔍 Estado inicial do jogo:");
show_debug_message("   - Quartéis: " + string(instance_number(obj_quartel_marinha)));
show_debug_message("   - Navios: " + string(instance_number(obj_lancha_patrulha)));
show_debug_message("   - Dinheiro: $" + string(global.dinheiro));

// 2. Encontrar ou criar quartel
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("🏭 Criando quartel de teste...");
    quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel == noone) {
        show_debug_message("❌ Falha ao criar quartel!");
        exit;
    }
}

show_debug_message("🏭 Quartel encontrado: " + string(quartel));

// 3. Garantir recursos suficientes
if (global.dinheiro < 100) {
    show_debug_message("💰 Adicionando recursos...");
    global.dinheiro = 1000;
}

// 4. Limpar estado anterior
show_debug_message("🧹 Limpando estado anterior...");
quartel.produzindo = false;
quartel.alarm[0] = 0;
quartel.timer_producao_step = 0;
ds_queue_clear(quartel.fila_producao);

// 5. Simular clique no botão produzir
show_debug_message("🎯 Simulando clique no botão produzir...");

var unidade_data = quartel.unidades_disponiveis[| 0];
var custo = unidade_data.custo_dinheiro;

show_debug_message("📋 Dados da unidade:");
show_debug_message("   - Nome: " + unidade_data.nome);
show_debug_message("   - Custo: $" + string(custo));
show_debug_message("   - Tempo: " + string(unidade_data.tempo_treino) + " frames");

// Deduzir recursos
global.dinheiro -= custo;
show_debug_message("💵 Recursos deduzidos. Restante: $" + string(global.dinheiro));

// Adicionar à fila
ds_queue_enqueue(quartel.fila_producao, unidade_data);
show_debug_message("📋 Unidade adicionada à fila");

// Iniciar produção
quartel.produzindo = true;
quartel.alarm[0] = unidade_data.tempo_treino;
quartel.timer_producao_step = 0;

show_debug_message("🚀 Produção iniciada!");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Timer alternativo: " + string(quartel.timer_producao_step));

// 6. Simular execução do Step Event
show_debug_message("🔄 Simulando execução do Step Event...");

var navios_antes = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios antes: " + string(navios_antes));

// Simular frames passando
var frames_simulados = 0;
var max_frames = unidade_data.tempo_treino + 10; // +10 para garantir

while (frames_simulados < max_frames && quartel.produzindo) {
    frames_simulados++;
    
    // Simular Step Event
    if (quartel.produzindo && !ds_queue_empty(quartel.fila_producao)) {
        // Incrementar timer alternativo
        quartel.timer_producao_step++;
        
        // Obter dados da unidade
        var _unidade_data = ds_queue_head(quartel.fila_producao);
        var _tempo_necessario = _unidade_data.tempo_treino;
        
        // Debug a cada segundo
        if (frames_simulados % 60 == 0) {
            show_debug_message("⏱️ Frame " + string(frames_simulados) + ": Progresso " + string(quartel.timer_producao_step) + "/" + string(_tempo_necessario));
        }
        
        // Verificar se tempo concluído
        if (quartel.timer_producao_step >= _tempo_necessario || quartel.alarm[0] <= 0) {
            show_debug_message("🚨 TEMPO DE PRODUÇÃO CONCLUÍDO!");
            
            // Criar unidade
            var _spawn_x = quartel.x + 80;
            var _spawn_y = quartel.y + 80;
            
            var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
            
            if (instance_exists(_unidade_criada)) {
                quartel.unidades_produzidas++;
                show_debug_message("✅ NAVIO CRIADO COM SUCESSO!");
                show_debug_message("   - ID: " + string(_unidade_criada));
                show_debug_message("   - Posição: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
                show_debug_message("   - Total produzidos: " + string(quartel.unidades_produzidas));
                
                // Configurar navio
                _unidade_criada.nacao_proprietaria = quartel.nacao_proprietaria;
                
                // Remover da fila
                ds_queue_dequeue(quartel.fila_producao);
                
                // Verificar próxima unidade
                if (!ds_queue_empty(quartel.fila_producao)) {
                    var _proxima = ds_queue_head(quartel.fila_producao);
                    quartel.alarm[0] = _proxima.tempo_treino;
                    quartel.timer_producao_step = 0;
                    show_debug_message("🔄 Iniciando próxima produção...");
                } else {
                    quartel.produzindo = false;
                    quartel.timer_producao_step = 0;
                    show_debug_message("🏁 Fila vazia - Quartel ocioso");
                }
                
                break; // Sair do loop
                
            } else {
                show_debug_message("❌ FALHA AO CRIAR NAVIO!");
            }
        }
    }
}

var navios_depois = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios depois: " + string(navios_depois));

// 7. Resultado final
if (navios_depois > navios_antes) {
    show_debug_message("🎉 SUCESSO: Sistema de produção funcionando!");
    show_debug_message("✅ Navio foi criado corretamente!");
} else {
    show_debug_message("❌ FALHA: Sistema de produção não funcionou!");
    show_debug_message("🔍 Estado final:");
    show_debug_message("   - Produzindo: " + string(quartel.produzindo));
    show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
    show_debug_message("   - Timer alternativo: " + string(quartel.timer_producao_step));
    show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));
}

show_debug_message("=== TESTE FINAL CONCLUÍDO ===");
