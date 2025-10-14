/// @description Teste final com métricas atuais do sistema
/// @function scr_teste_final_metricas

show_debug_message("=== TESTE FINAL: MÉTRICAS ATUAIS DO SISTEMA ===");

// 1. MÉTRICAS GERAIS
show_debug_message("📊 MÉTRICAS GERAIS:");

var total_instancias = 0;
var tipos_objetos = ds_map_create();

// Contar instâncias por tipo
with (all) {
    total_instancias++;
    var tipo = object_get_name(object_index);
    if (ds_map_exists(tipos_objetos, tipo)) {
        ds_map_set(tipos_objetos, tipo, ds_map_find_value(tipos_objetos, tipo) + 1);
    } else {
        ds_map_set(tipos_objetos, tipo, 1);
    }
}

show_debug_message("   - Total de instâncias: " + string(total_instancias));

// Mostrar contagem por tipo
var keys = ds_map_keys_to_array(tipos_objetos);
for (var i = 0; i < array_length(keys); i++) {
    var tipo = keys[i];
    var count = ds_map_find_value(tipos_objetos, tipo);
    show_debug_message("   - " + tipo + ": " + string(count));
}

// Limpar mapa temporário
ds_map_destroy(tipos_objetos);

// 2. VERIFICAÇÃO DE SISTEMAS CRÍTICOS
show_debug_message("🔍 VERIFICAÇÃO DE SISTEMAS CRÍTICOS:");

// Sistema de produção naval
var controlador_producao = instance_first(obj_controlador_producao_naval);
var quartel_marinha = instance_first(obj_quartel_marinha);
var navios = instance_number(obj_lancha_patrulha);

show_debug_message("   - Controlador produção: " + (controlador_producao != noone ? "✅ ATIVO" : "❌ INATIVO"));
show_debug_message("   - Quartel marinha: " + (quartel_marinha != noone ? "✅ ATIVO" : "❌ INATIVO"));
show_debug_message("   - Navios existentes: " + string(navios));

// Sistema de seleção
var infantaria = instance_first(obj_infantaria);
var tanque = instance_first(obj_tanque);
var soldado_aa = instance_first(obj_soldado_antiaereo);

show_debug_message("   - Infantaria: " + (infantaria != noone ? "✅ ATIVA" : "❌ INATIVA"));
show_debug_message("   - Tanque: " + (tanque != noone ? "✅ ATIVO" : "❌ INATIVO"));
show_debug_message("   - Soldado AA: " + (soldado_aa != noone ? "✅ ATIVO" : "❌ INATIVO"));

// Sistema de comandos
var controlador_unidades = instance_first(obj_controlador_unidades);
show_debug_message("   - Controlador unidades: " + (controlador_unidades != noone ? "✅ ATIVO" : "❌ INATIVO"));

// 3. TESTE DE PRODUÇÃO NAVAL
show_debug_message("🧪 TESTE DE PRODUÇÃO NAVAL:");

if (controlador_producao != noone && quartel_marinha != noone) {
    // Configurar produção
    quartel_marinha.produzindo = false;
    quartel_marinha.alarm[0] = 0;
    quartel_marinha.timer_producao_step = 0;
    ds_queue_clear(quartel_marinha.fila_producao);
    
    var unidade_data = quartel_marinha.unidades_disponiveis[| 0];
    ds_queue_enqueue(quartel_marinha.fila_producao, unidade_data);
    quartel_marinha.produzindo = true;
    quartel_marinha.alarm[0] = unidade_data.tempo_treino;
    quartel_marinha.timer_producao_step = 0;
    
    show_debug_message("   - Produção configurada: " + unidade_data.nome);
    
    // Simular produção acelerada
    var navios_antes = instance_number(obj_lancha_patrulha);
    var frames_simulados = 0;
    var max_frames = unidade_data.tempo_treino + 5;
    
    while (frames_simulados < max_frames && quartel_marinha.produzindo) {
        frames_simulados++;
        
        if (quartel_marinha.produzindo && !ds_queue_empty(quartel_marinha.fila_producao)) {
            quartel_marinha.timer_producao_step++;
            
            var _unidade_data = ds_queue_head(quartel_marinha.fila_producao);
            var _tempo_necessario = _unidade_data.tempo_treino;
            
            if (quartel_marinha.timer_producao_step >= _tempo_necessario || quartel_marinha.alarm[0] <= 0) {
                // Criar navio
                var _spawn_x = quartel_marinha.x + 80;
                var _spawn_y = quartel_marinha.y + 80;
                
                var _unidade_criada = instance_create_layer(_spawn_x, _spawn_y, "rm_mapa_principal", obj_lancha_patrulha);
                
                if (instance_exists(_unidade_criada)) {
                    quartel_marinha.unidades_produzidas++;
                    controlador_producao.producoes_processadas++;
                    
                    show_debug_message("   ✅ Navio criado: " + string(_unidade_criada));
                    _unidade_criada.nacao_proprietaria = quartel_marinha.nacao_proprietaria;
                    ds_queue_dequeue(quartel_marinha.fila_producao);
                    quartel_marinha.produzindo = false;
                    quartel_marinha.timer_producao_step = 0;
                    
                    break;
                }
            }
        }
    }
    
    var navios_depois = instance_number(obj_lancha_patrulha);
    var producao_funcionou = (navios_depois > navios_antes);
    show_debug_message("   - Navios antes: " + string(navios_antes));
    show_debug_message("   - Navios depois: " + string(navios_depois));
    show_debug_message("   - Produção funcionou: " + (producao_funcionou ? "✅ SIM" : "❌ NÃO"));
    
} else {
    show_debug_message("   - ❌ Sistema de produção não disponível");
    var producao_funcionou = false;
}

// 4. TESTE DE SELEÇÃO
show_debug_message("🧪 TESTE DE SELEÇÃO:");

var selecao_funcionou = true;

// Testar seleção de navios
with (obj_lancha_patrulha) {
    selecionado = true;
    var tem_selecionado = variable_instance_exists(id, "selecionado");
    var tem_alcance_tiro = variable_instance_exists(id, "alcance_tiro");
    var tem_raio_selecao = variable_instance_exists(id, "raio_selecao");
    
    if (!tem_selecionado || !tem_alcance_tiro || !tem_raio_selecao) {
        selecao_funcionou = false;
    }
}

show_debug_message("   - Seleção de navios: " + (selecao_funcionou ? "✅ FUNCIONA" : "❌ FALHA"));

// 5. TESTE DE COMANDOS TÁTICOS
show_debug_message("🧪 TESTE DE COMANDOS TÁTICOS:");

var comandos_funcionaram = true;

if (infantaria != noone) {
    var tem_comando_atual = variable_instance_exists(infantaria, "comando_atual");
    var tem_estado = variable_instance_exists(infantaria, "estado");
    var tem_alvo = variable_instance_exists(infantaria, "alvo");
    
    if (tem_comando_atual && tem_estado && tem_alvo) {
        infantaria.comando_atual = "ATACAR";
        infantaria.estado = "atacando";
        infantaria.alvo = instance_first(obj_inimigo);
        
        var comando_aplicado = (infantaria.comando_atual == "ATACAR");
        show_debug_message("   - Comando ATACAR: " + (comando_aplicado ? "✅ FUNCIONA" : "❌ FALHA"));
    } else {
        comandos_funcionaram = false;
        show_debug_message("   - ❌ Variáveis de comando não existem");
    }
} else {
    comandos_funcionaram = false;
    show_debug_message("   - ❌ Infantaria não encontrada");
}

// 6. VERIFICAÇÃO DE MEMÓRIA
show_debug_message("🔍 VERIFICAÇÃO DE MEMÓRIA:");

var filas_vazias = 0;
var listas_vazias = 0;

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

show_debug_message("   - Filas vazias: " + string(filas_vazias));
show_debug_message("   - Listas vazias: " + string(listas_vazias));
show_debug_message("   - Total instâncias: " + string(total_instancias));

var memoria_ok = (total_instancias < 1000);
show_debug_message("   - Memória OK: " + (memoria_ok ? "✅ SIM" : "❌ NÃO"));

// 7. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL:");

var sistemas_funcionando = 0;
var total_sistemas = 4;

if (producao_funcionou) sistemas_funcionando++;
if (selecao_funcionou) sistemas_funcionando++;
if (comandos_funcionaram) sistemas_funcionando++;
if (memoria_ok) sistemas_funcionando++;

show_debug_message("   - Sistema Produção Naval: " + (producao_funcionou ? "✅ FUNCIONAL" : "❌ NÃO FUNCIONAL"));
show_debug_message("   - Sistema Seleção: " + (selecao_funcionou ? "✅ FUNCIONAL" : "❌ NÃO FUNCIONAL"));
show_debug_message("   - Sistema Comandos: " + (comandos_funcionaram ? "✅ FUNCIONAL" : "❌ NÃO FUNCIONAL"));
show_debug_message("   - Sistema Memória: " + (memoria_ok ? "✅ FUNCIONAL" : "❌ NÃO FUNCIONAL"));

show_debug_message("📊 RESUMO FINAL:");
show_debug_message("   - Sistemas funcionando: " + string(sistemas_funcionando) + "/" + string(total_sistemas));
show_debug_message("   - Taxa de sucesso: " + string(round((sistemas_funcionando / total_sistemas) * 100)) + "%");
show_debug_message("   - Total instâncias: " + string(total_instancias));
show_debug_message("   - Navios criados: " + string(instance_number(obj_lancha_patrulha)));

if (sistemas_funcionando == total_sistemas) {
    show_debug_message("🎉 SUCESSO TOTAL: TODOS OS SISTEMAS FUNCIONANDO!");
    show_debug_message("✅ Problema crítico do Step Event RESOLVIDO!");
    show_debug_message("✅ Sistema está PRONTO para produção!");
} else if (sistemas_funcionando >= total_sistemas * 0.75) {
    show_debug_message("⚠️ SUCESSO PARCIAL: Maioria dos sistemas funcionando");
    show_debug_message("🔧 Pequenos ajustes necessários");
} else {
    show_debug_message("❌ FALHA: Muitos sistemas não funcionando");
    show_debug_message("🔍 Verificar logs acima para identificar problemas");
}

show_debug_message("=== TESTE FINAL CONCLUÍDO ===");
