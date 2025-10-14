/// @description Sistema de produção naval independente do Step Event
/// @function scr_sistema_producao_independente

show_debug_message("=== SISTEMA DE PRODUÇÃO INDEPENDENTE ===");

// 1. VERIFICAR SE JÁ EXISTE CONTROLADOR DE PRODUÇÃO
var controlador_producao = instance_first(obj_controlador_producao_naval);
if (controlador_producao == noone) {
    show_debug_message("🎮 Criando controlador de produção naval...");
    controlador_producao = instance_create_layer(0, 0, "GUI", obj_controlador_producao_naval);
    if (controlador_producao == noone) {
        show_debug_message("❌ Falha ao criar controlador!");
        exit;
    }
}

show_debug_message("✅ Controlador encontrado: " + string(controlador_producao));

// 2. VERIFICAR QUARTÉIS
var quartel_count = instance_number(obj_quartel_marinha);
show_debug_message("🏭 Quartéis encontrados: " + string(quartel_count));

if (quartel_count == 0) {
    show_debug_message("🏭 Criando quartel de teste...");
    var quartel_teste = instance_create_layer(200, 200, "rm_mapa_principal", obj_quartel_marinha);
    if (quartel_teste != noone) {
        show_debug_message("✅ Quartel criado: " + string(quartel_teste));
    }
}

// 3. CONFIGURAR PRODUÇÃO
with (obj_quartel_marinha) {
    show_debug_message("🏭 Configurando quartel: " + string(id));
    
    // Limpar estado anterior
    produzindo = false;
    alarm[0] = 0;
    timer_producao_step = 0;
    ds_queue_clear(fila_producao);
    
    // Adicionar unidade à fila
    var unidade_data = unidades_disponiveis[| 0];
    ds_queue_enqueue(fila_producao, unidade_data);
    
    show_debug_message("📋 Unidade adicionada: " + unidade_data.nome);
    show_debug_message("⏱️ Tempo de produção: " + string(unidade_data.tempo_treino) + " frames");
    
    // Configurar produção
    produzindo = true;
    alarm[0] = unidade_data.tempo_treino;
    timer_producao_step = 0;
    
    show_debug_message("🚀 Produção configurada:");
    show_debug_message("   - Produzindo: " + string(produzindo));
    show_debug_message("   - Alarm[0]: " + string(alarm[0]));
    show_debug_message("   - Timer alternativo: " + string(timer_producao_step));
}

// 4. INICIAR MONITORAMENTO
show_debug_message("🔄 Iniciando monitoramento de produção...");

// O controlador irá monitorar e processar a produção
controlador_producao.monitorando = true;
controlador_producao.timer_monitoramento = 0;

show_debug_message("✅ Sistema de produção independente ativado!");
show_debug_message("💡 O controlador irá processar a produção automaticamente");

show_debug_message("=== SISTEMA INDEPENDENTE CONCLUÍDO ===");
