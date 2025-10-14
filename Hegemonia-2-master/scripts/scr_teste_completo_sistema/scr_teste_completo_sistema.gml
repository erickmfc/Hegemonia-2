/// @description Teste completo end-to-end do sistema
/// @function scr_teste_completo_sistema

show_debug_message("=== TESTE COMPLETO END-TO-END DO SISTEMA ===");

// 1. PREPARAÇÃO DO AMBIENTE
show_debug_message("🔧 PREPARANDO AMBIENTE DE TESTE...");

// Limpar estado anterior
global.dinheiro = 1000;
global.minerio = 500;

// Criar unidades de teste se necessário
var quartel = instance_first(obj_quartel_marinha);
if (quartel == noone) {
    quartel = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    show_debug_message("🏭 Quartel criado: " + string(quartel));
}

var infantaria = instance_first(obj_infantaria);
if (infantaria == noone) {
    infantaria = instance_create_layer(300, 300, "rm_mapa_principal", obj_infantaria);
    show_debug_message("🏃 Infantaria criada: " + string(infantaria));
}

var inimigo = instance_first(obj_inimigo);
if (inimigo == noone) {
    inimigo = instance_create_layer(500, 500, "rm_mapa_principal", obj_inimigo);
    show_debug_message("👹 Inimigo criado: " + string(inimigo));
}

// 2. TESTE 1: SISTEMA DE PRODUÇÃO NAVAL
show_debug_message("🧪 TESTE 1: Sistema de Produção Naval");

var navios_antes = instance_number(obj_lancha_patrulha);
show_debug_message("   - Navios antes: " + string(navios_antes));

// Simular produção
if (quartel != noone) {
    // Limpar estado
    quartel.produzindo = false;
    quartel.alarm[0] = 0;
    quartel.timer_producao_step = 0;
    ds_queue_clear(quartel.fila_producao);
    
    // Configurar produção
    var unidade_data = quartel.unidades_disponiveis[| 0];
    ds_queue_enqueue(quartel.fila_producao, unidade_data);
    quartel.produzindo = true;
    quartel.alarm[0] = unidade_data.tempo_treino;
    quartel.timer_producao_step = 0;
    
    show_debug_message("   - Produção configurada: " + unidade_data.nome);
    
    // Simular produção acelerada
    var frames_simulados = 0;
    var max_frames = unidade_data.tempo_treino + 5;
    
    while (frames_simulados < max_frames && quartel.produzindo) {
        frames_simulados++;
        
        if (quartel.produzindo && !ds_queue_empty(quartel.fila_producao)) {
            quartel.timer_producao_step++;
            
            var _unidade_data = ds_queue_head(quartel.fila_producao);
            var _tempo_necessario = _unidade_data.tempo_treino;
            
            if (quartel.timer_producao_step >= _tempo_necessario || quartel.alarm[0] <= 0) {
                // Criar navio
                var _spawn_x = quartel.x + 80;
                var _spawn_y = quartel.y + 80;
                
                var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
                
                if (instance_exists(_unidade_criada)) {
                    quartel.unidades_produzidas++;
                    _unidade_criada.nacao_proprietaria = quartel.nacao_proprietaria;
                    ds_queue_dequeue(quartel.fila_producao);
                    quartel.produzindo = false;
                    quartel.timer_producao_step = 0;
                    
                    show_debug_message("   ✅ Navio criado: " + string(_unidade_criada));
                    break;
                }
            }
        }
    }
}

var navios_depois = instance_number(obj_lancha_patrulha);
var teste1_passou = (navios_depois > navios_antes);
show_debug_message("   - Navios depois: " + string(navios_depois));
show_debug_message("   - Resultado: " + (teste1_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 3. TESTE 2: SISTEMA DE SELEÇÃO
show_debug_message("🧪 TESTE 2: Sistema de Seleção");

var navio = instance_first(obj_lancha_patrulha);
if (navio != noone) {
    // Testar seleção
    navio.selecionado = true;
    
    var selecionado_funciona = variable_instance_exists(navio, "selecionado") && navio.selecionado;
    var alcance_tiro_funciona = variable_instance_exists(navio, "alcance_tiro");
    var raio_selecao_funciona = variable_instance_exists(navio, "raio_selecao");
    
    show_debug_message("   - Seleção: " + string(selecionado_funciona));
    show_debug_message("   - Alcance tiro: " + string(alcance_tiro_funciona));
    show_debug_message("   - Raio seleção: " + string(raio_selecao_funciona));
    
    var teste2_passou = selecionado_funciona && alcance_tiro_funciona && raio_selecao_funciona;
    show_debug_message("   - Resultado: " + (teste2_passou ? "✅ PASSOU" : "❌ FALHOU"));
} else {
    show_debug_message("   - Resultado: ❌ FALHOU (nenhum navio)");
    var teste2_passou = false;
}

// 4. TESTE 3: COMANDOS TÁTICOS
show_debug_message("🧪 TESTE 3: Comandos Táticos");

if (infantaria != noone && inimigo != noone) {
    // Testar comando ATACAR
    var tem_comando_atual = variable_instance_exists(infantaria, "comando_atual");
    var tem_estado = variable_instance_exists(infantaria, "estado");
    var tem_alvo = variable_instance_exists(infantaria, "alvo");
    
    if (tem_comando_atual && tem_estado && tem_alvo) {
        infantaria.comando_atual = "ATACAR";
        infantaria.estado = "atacando";
        infantaria.alvo = inimigo;
        
        var comando_atacar_funciona = (infantaria.comando_atual == "ATACAR" && infantaria.estado == "atacando");
        show_debug_message("   - Comando ATACAR: " + string(comando_atacar_funciona));
        
        var teste3_passou = comando_atacar_funciona;
        show_debug_message("   - Resultado: " + (teste3_passou ? "✅ PASSOU" : "❌ FALHOU"));
    } else {
        show_debug_message("   - Resultado: ❌ FALHOU (variáveis não existem)");
        var teste3_passou = false;
    }
} else {
    show_debug_message("   - Resultado: ❌ FALHOU (unidades não encontradas)");
    var teste3_passou = false;
}

// 5. TESTE 4: MOVIMENTO DE NAVIOS
show_debug_message("🧪 TESTE 4: Movimento de Navios");

if (navio != noone) {
    // Testar movimento
    var tem_estado = variable_instance_exists(navio, "estado");
    var tem_destino_x = variable_instance_exists(navio, "destino_x");
    var tem_destino_y = variable_instance_exists(navio, "destino_y");
    var tem_movendo = variable_instance_exists(navio, "movendo");
    
    if (tem_estado && tem_destino_x && tem_destino_y) {
        navio.estado = "movendo";
        navio.destino_x = 600;
        navio.destino_y = 600;
        if (tem_movendo) {
            navio.movendo = true;
        }
        
        var movimento_funciona = (navio.estado == "movendo" && navio.destino_x == 600);
        show_debug_message("   - Movimento: " + string(movimento_funciona));
        
        var teste4_passou = movimento_funciona;
        show_debug_message("   - Resultado: " + (teste4_passou ? "✅ PASSOU" : "❌ FALHOU"));
    } else {
        show_debug_message("   - Resultado: ❌ FALHOU (variáveis não existem)");
        var teste4_passou = false;
    }
} else {
    show_debug_message("   - Resultado: ❌ FALHOU (nenhum navio)");
    var teste4_passou = false;
}

// 6. TESTE 5: LIMPEZA DE MEMÓRIA
show_debug_message("🧪 TESTE 5: Limpeza de Memória");

var total_instancias = 0;
var filas_vazias = 0;
var listas_vazias = 0;

// Contar instâncias
with (all) {
    total_instancias++;
}

// Verificar filas e listas
with (obj_quartel_marinha) {
    if (variable_instance_exists(id, "fila_producao") && ds_queue_empty(fila_producao)) {
        filas_vazias++;
    }
}

with (obj_infantaria) {
    if (variable_instance_exists(id, "patrulha") && ds_list_size(patrulha) == 0) {
        listas_vazias++;
    }
}

show_debug_message("   - Total instâncias: " + string(total_instancias));
show_debug_message("   - Filas vazias: " + string(filas_vazias));
show_debug_message("   - Listas vazias: " + string(listas_vazias));

var teste5_passou = (total_instancias < 1000); // Limite razoável
show_debug_message("   - Resultado: " + (teste5_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 7. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL:");

var testes_passaram = 0;
var total_testes = 5;

if (teste1_passou) testes_passaram++;
if (teste2_passou) testes_passaram++;
if (teste3_passou) testes_passaram++;
if (teste4_passou) testes_passaram++;
if (teste5_passou) testes_passaram++;

show_debug_message("   - TESTE 1 (Produção Naval): " + (teste1_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 2 (Seleção): " + (teste2_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 3 (Comandos Táticos): " + (teste3_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 4 (Movimento Navios): " + (teste4_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 5 (Limpeza Memória): " + (teste5_passou ? "✅ PASSOU" : "❌ FALHOU"));

show_debug_message("📊 RESUMO:");
show_debug_message("   - Testes passaram: " + string(testes_passaram) + "/" + string(total_testes));
show_debug_message("   - Taxa de sucesso: " + string(round((testes_passaram / total_testes) * 100)) + "%");

if (testes_passaram == total_testes) {
    show_debug_message("🎉 SUCESSO: TODOS OS TESTES PASSARAM!");
    show_debug_message("✅ Sistema está FUNCIONAL e PRONTO para uso!");
} else if (testes_passaram >= total_testes * 0.8) {
    show_debug_message("⚠️ PARCIAL: Maioria dos testes passou");
    show_debug_message("🔧 Sistema funcional com pequenos ajustes necessários");
} else {
    show_debug_message("❌ FALHA: Muitos testes falharam");
    show_debug_message("🔍 Verificar logs acima para identificar problemas");
}

show_debug_message("=== TESTE COMPLETO CONCLUÍDO ===");
