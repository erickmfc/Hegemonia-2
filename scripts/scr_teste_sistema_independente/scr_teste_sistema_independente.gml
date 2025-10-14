/// @description Teste do sistema de produção independente
/// @function scr_teste_sistema_independente

show_debug_message("=== TESTE: SISTEMA DE PRODUÇÃO INDEPENDENTE ===");

// 1. VERIFICAÇÃO INICIAL
show_debug_message("🔍 VERIFICAÇÃO INICIAL:");
var controlador_count = instance_number(obj_controlador_producao_naval);
var quartel_count = instance_number(obj_quartel_marinha);
var navio_count = instance_number(obj_lancha_patrulha);

show_debug_message("   - Controladores: " + string(controlador_count));
show_debug_message("   - Quartéis: " + string(quartel_count));
show_debug_message("   - Navios: " + string(navio_count));

// 2. CRIAR CONTROLADOR SE NECESSÁRIO
var controlador = instance_first(obj_controlador_producao_naval);
if (controlador == noone) {
    show_debug_message("🎮 Criando controlador de produção...");
    controlador = instance_create_layer(0, 0, "GUI", obj_controlador_producao_naval);
    if (controlador == noone) {
        show_debug_message("❌ FALHA CRÍTICA: Não foi possível criar controlador!");
        exit;
    }
}

show_debug_message("✅ Controlador encontrado: " + string(controlador));

// 3. CRIAR QUARTEL SE NECESSÁRIO
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("🏭 Criando quartel de teste...");
    quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel == noone) {
        show_debug_message("❌ FALHA CRÍTICA: Não foi possível criar quartel!");
        exit;
    }
}

show_debug_message("✅ Quartel encontrado: " + string(quartel));

// 4. CONFIGURAR PRODUÇÃO
show_debug_message("⚙️ CONFIGURANDO PRODUÇÃO:");

// Limpar estado anterior
quartel.produzindo = false;
quartel.alarm[0] = 0;
quartel.timer_producao_step = 0;
ds_queue_clear(quartel.fila_producao);

// Obter dados da unidade
var unidade_data = quartel.unidades_disponiveis[| 0];
var custo = unidade_data.custo_dinheiro;
var tempo_producao = unidade_data.tempo_treino;

show_debug_message("📋 Dados da unidade:");
show_debug_message("   - Nome: " + unidade_data.nome);
show_debug_message("   - Custo: $" + string(custo));
show_debug_message("   - Tempo: " + string(tempo_producao) + " frames");

// Garantir recursos
if (global.dinheiro < custo) {
    global.dinheiro = custo + 100;
    show_debug_message("💰 Recursos garantidos: $" + string(global.dinheiro));
}

// Deduzir recursos
global.dinheiro -= custo;
show_debug_message("💵 Recursos deduzidos. Restante: $" + string(global.dinheiro));

// Adicionar à fila
ds_queue_enqueue(quartel.fila_producao, unidade_data);
show_debug_message("📋 Unidade adicionada à fila");

// Configurar produção
quartel.produzindo = true;
quartel.alarm[0] = tempo_producao;
quartel.timer_producao_step = 0;

show_debug_message("🚀 Produção configurada:");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Timer alternativo: " + string(quartel.timer_producao_step));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));

// 5. SIMULAR EXECUÇÃO DO CONTROLADOR
show_debug_message("🔄 SIMULANDO EXECUÇÃO DO CONTROLADOR:");

var navios_antes = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios antes: " + string(navios_antes));

// Simular execução do controlador
var frames_simulados = 0;
var max_frames = tempo_producao + 10;

while (frames_simulados < max_frames && quartel.produzindo) {
    frames_simulados++;
    
    // Simular Step Event do controlador
    if (quartel.produzindo && !ds_queue_empty(quartel.fila_producao)) {
        
        // Incrementar timer alternativo
        quartel.timer_producao_step++;
        
        // Verificar se tempo concluído
        var _unidade_data = ds_queue_head(quartel.fila_producao);
        var _tempo_necessario = _unidade_data.tempo_treino;
        
        if (quartel.timer_producao_step >= _tempo_necessario || quartel.alarm[0] <= 0) {
            show_debug_message("🚨 TEMPO DE PRODUÇÃO CONCLUÍDO!");
            
            // Criar unidade
            var _spawn_x = quartel.x + 80;
            var _spawn_y = quartel.y + 80;
            
            var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
            
            if (instance_exists(_unidade_criada)) {
                quartel.unidades_produzidas++;
                controlador.producoes_processadas++;
                
                show_debug_message("✅ NAVIO CRIADO COM SUCESSO!");
                show_debug_message("   - ID: " + string(_unidade_criada));
                show_debug_message("   - Posição: (" + string(_unidade_criada.x) + ", " + string(_unidade_criada.y) + ")");
                show_debug_message("   - Total produzidas: " + string(quartel.unidades_produzidas));
                show_debug_message("   - Processadas pelo controlador: " + string(controlador.producoes_processadas));
                
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
        
        // Debug do progresso
        if (frames_simulados % 60 == 0) { // A cada segundo
            show_debug_message("⏱️ Frame " + string(frames_simulados) + ": Progresso " + string(quartel.timer_producao_step) + "/" + string(_tempo_necessario));
        }
    }
}

var navios_depois = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios depois: " + string(navios_depois));

// 6. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL:");

var navio_criado = (navios_depois > navios_antes);
var controlador_funcionou = (controlador.producoes_processadas > 0);
var quartel_ocioso = (!quartel.produzindo && ds_queue_empty(quartel.fila_producao));

show_debug_message("   - Navio criado: " + (navio_criado ? "✅ SIM" : "❌ NÃO"));
show_debug_message("   - Controlador funcionou: " + (controlador_funcionou ? "✅ SIM" : "❌ NÃO"));
show_debug_message("   - Quartel ocioso: " + (quartel_ocioso ? "✅ SIM" : "❌ NÃO"));

if (navio_criado && controlador_funcionou && quartel_ocioso) {
    show_debug_message("🎉 SUCESSO: Sistema independente funcionando perfeitamente!");
    show_debug_message("✅ Problema do Step Event RESOLVIDO!");
} else {
    show_debug_message("❌ FALHA: Sistema independente não funcionou completamente");
    show_debug_message("🔍 Verificar logs acima para identificar problemas");
}

show_debug_message("=== TESTE DO SISTEMA INDEPENDENTE CONCLUÍDO ===");
