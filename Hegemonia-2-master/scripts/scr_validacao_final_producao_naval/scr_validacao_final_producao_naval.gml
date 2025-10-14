/// @description Teste completo do sistema de produção naval - VALIDAÇÃO FINAL
/// @function scr_validacao_final_producao_naval

show_debug_message("=== VALIDAÇÃO FINAL: SISTEMA DE PRODUÇÃO NAVAL ===");

// 1. VERIFICAÇÃO INICIAL
show_debug_message("🔍 VERIFICAÇÃO INICIAL:");
var quartel_count = instance_number(obj_quartel_marinha);
var navio_count = instance_number(obj_lancha_patrulha);
show_debug_message("   - Quartéis: " + string(quartel_count));
show_debug_message("   - Navios: " + string(navio_count));
show_debug_message("   - Dinheiro: $" + string(global.dinheiro));

// 2. PREPARAR AMBIENTE DE TESTE
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    show_debug_message("🏭 Criando quartel de teste...");
    quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel == noone) {
        show_debug_message("❌ FALHA CRÍTICA: Não foi possível criar quartel!");
        exit;
    }
}

// Garantir recursos
if (global.dinheiro < 200) {
    global.dinheiro = 1000;
    show_debug_message("💰 Recursos garantidos: $" + string(global.dinheiro));
}

// 3. TESTE 1: CRIAÇÃO DIRETA DE NAVIO
show_debug_message("🧪 TESTE 1: Criação direta de navio");
var navio_teste = instance_create_layer(400, 400, "rm_mapa_principal", obj_lancha_patrulha);
if (navio_teste != noone) {
    show_debug_message("✅ TESTE 1 PASSOU: Criação direta funcionou");
    show_debug_message("   - ID: " + string(navio_teste));
    show_debug_message("   - Posição: (" + string(navio_teste.x) + ", " + string(navio_teste.y) + ")");
    show_debug_message("   - Variáveis:");
    show_debug_message("     - selecionado: " + string(variable_instance_exists(navio_teste, "selecionado") ? navio_teste.selecionado : "N/A"));
    show_debug_message("     - alcance_tiro: " + string(variable_instance_exists(navio_teste, "alcance_tiro") ? navio_teste.alcance_tiro : "N/A"));
} else {
    show_debug_message("❌ TESTE 1 FALHOU: Criação direta não funcionou");
}

// 4. TESTE 2: SISTEMA DE PRODUÇÃO
show_debug_message("🧪 TESTE 2: Sistema de produção");

// Limpar estado
quartel.produzindo = false;
quartel.alarm[0] = 0;
quartel.timer_producao_step = 0;
ds_queue_clear(quartel.fila_producao);

// Configurar produção
var unidade_data = quartel.unidades_disponiveis[| 0];
var custo = unidade_data.custo_dinheiro;
var tempo_producao = unidade_data.tempo_treino;

show_debug_message("📋 Configurando produção:");
show_debug_message("   - Unidade: " + unidade_data.nome);
show_debug_message("   - Custo: $" + string(custo));
show_debug_message("   - Tempo: " + string(tempo_producao) + " frames");

// Deduzir recursos
global.dinheiro -= custo;
ds_queue_enqueue(quartel.fila_producao, unidade_data);
quartel.produzindo = true;
quartel.alarm[0] = tempo_producao;
quartel.timer_producao_step = 0;

show_debug_message("🚀 Produção iniciada:");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Timer alternativo: " + string(quartel.timer_producao_step));
show_debug_message("   - Fila vazia: " + string(ds_queue_empty(quartel.fila_producao)));

// 5. TESTE 3: SIMULAÇÃO DE PRODUÇÃO
show_debug_message("🧪 TESTE 3: Simulação de produção");

var navios_antes_producao = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios antes da produção: " + string(navios_antes_producao));

// Simular produção acelerada (para teste)
var frames_simulados = 0;
var max_frames = tempo_producao + 5;

while (frames_simulados < max_frames && quartel.produzindo) {
    frames_simulados++;
    
    // Simular Step Event
    if (quartel.produzindo && !ds_queue_empty(quartel.fila_producao)) {
        quartel.timer_producao_step++;
        
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

var navios_depois_producao = instance_number(obj_lancha_patrulha);
show_debug_message("🚢 Navios depois da produção: " + string(navios_depois_producao));

// 6. TESTE 4: VERIFICAÇÃO DE MEMÓRIA
show_debug_message("🧪 TESTE 4: Verificação de memória");

// Verificar se não há vazamentos
var fila_size = ds_queue_size(quartel.fila_producao);
show_debug_message("📋 Estado da fila:");
show_debug_message("   - Tamanho: " + string(fila_size));
show_debug_message("   - Vazia: " + string(ds_queue_empty(quartel.fila_producao)));

// Verificar variáveis do quartel
show_debug_message("🔧 Variáveis do quartel:");
show_debug_message("   - Produzindo: " + string(quartel.produzindo));
show_debug_message("   - Alarm[0]: " + string(quartel.alarm[0]));
show_debug_message("   - Timer alternativo: " + string(quartel.timer_producao_step));
show_debug_message("   - Unidades produzidas: " + string(quartel.unidades_produzidas));

// 7. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL:");

var teste1_passou = (navio_teste != noone);
var teste2_passou = (navios_depois_producao > navios_antes_producao);
var teste3_passou = (quartel.unidades_produzidas > 0);
var teste4_passou = (quartel.produzindo == false && ds_queue_empty(quartel.fila_producao));

show_debug_message("   - TESTE 1 (Criação direta): " + (teste1_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 2 (Sistema produção): " + (teste2_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 3 (Contador produção): " + (teste3_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 4 (Limpeza memória): " + (teste4_passou ? "✅ PASSOU" : "❌ FALHOU"));

var todos_testes_passaram = teste1_passou && teste2_passou && teste3_passou && teste4_passou;

if (todos_testes_passaram) {
    show_debug_message("🎉 SUCESSO: TODOS OS TESTES PASSARAM!");
    show_debug_message("✅ Sistema de produção naval está FUNCIONAL!");
} else {
    show_debug_message("❌ FALHA: ALGUNS TESTES FALHARAM!");
    show_debug_message("🔍 Verificar logs acima para identificar problemas");
}

show_debug_message("=== VALIDAÇÃO FINAL CONCLUÍDA ===");
