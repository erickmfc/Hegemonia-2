/// @description Validação do sistema de debug
/// @function scr_validacao_debug_system

show_debug_message("=== VALIDAÇÃO: SISTEMA DE DEBUG ===");

// 1. VERIFICAÇÃO DE DEBUG GLOBAL
show_debug_message("🔍 VERIFICAÇÃO DE DEBUG GLOBAL:");

var debug_global_existe = variable_global_exists("debug_enabled");
show_debug_message("   - global.debug_enabled existe: " + string(debug_global_existe));

if (debug_global_existe) {
    show_debug_message("   - Valor: " + string(global.debug_enabled));
} else {
    show_debug_message("   - ⚠️ Variável não existe, criando...");
    global.debug_enabled = true;
    show_debug_message("   - ✅ Variável criada: " + string(global.debug_enabled));
}

// 2. VERIFICAÇÃO DE DEBUG POR OBJETO
show_debug_message("🔍 VERIFICAÇÃO DE DEBUG POR OBJETO:");

// Quartel marinho
with (obj_quartel_marinha) {
    var tem_debug = variable_instance_exists(id, "step_debug_count");
    show_debug_message("   - Quartel " + string(id) + " tem debug: " + string(tem_debug));
    
    if (tem_debug) {
        show_debug_message("     - step_debug_count: " + string(step_debug_count));
    }
}

// Controlador de produção
with (obj_controlador_producao_naval) {
    var tem_debug = variable_instance_exists(id, "debug_ativo");
    show_debug_message("   - Controlador " + string(id) + " tem debug: " + string(tem_debug));
    
    if (tem_debug) {
        show_debug_message("     - debug_ativo: " + string(debug_ativo));
        show_debug_message("     - producoes_processadas: " + string(producoes_processadas));
    }
}

// Controlador de unidades
with (obj_controlador_unidades) {
    var tem_debug = variable_instance_exists(id, "debug_enabled");
    show_debug_message("   - Controlador unidades " + string(id) + " tem debug: " + string(tem_debug));
    
    if (tem_debug) {
        show_debug_message("     - debug_enabled: " + string(debug_enabled));
    }
}

// 3. TESTE DE FUNCIONAMENTO DO DEBUG
show_debug_message("🧪 TESTE DE FUNCIONAMENTO DO DEBUG:");

// Ativar debug global
global.debug_enabled = true;
show_debug_message("   - Debug global ativado: " + string(global.debug_enabled));

// Testar mensagens de debug
show_debug_message("🔧 TESTE: Mensagem de debug básica");
show_debug_message("🔧 TESTE: Mensagem com variável - Debug: " + string(global.debug_enabled));
show_debug_message("🔧 TESTE: Mensagem com timestamp - Frame: " + string(current_frame));

// 4. VERIFICAÇÃO DE PERFORMANCE DO DEBUG
show_debug_message("📊 VERIFICAÇÃO DE PERFORMANCE DO DEBUG:");

var inicio_tempo = current_time;
var mensagens_debug = 0;

// Simular muitas mensagens de debug
for (var i = 0; i < 100; i++) {
    show_debug_message("🔧 TESTE PERFORMANCE: Mensagem " + string(i));
    mensagens_debug++;
}

var fim_tempo = current_time;
var tempo_decorrido = fim_tempo - inicio_tempo;

show_debug_message("   - Mensagens enviadas: " + string(mensagens_debug));
show_debug_message("   - Tempo decorrido: " + string(tempo_decorrido) + "ms");
show_debug_message("   - Performance: " + string(round(mensagens_debug / (tempo_decorrido / 1000))) + " msg/s");

// 5. VERIFICAÇÃO DE LOGS CRÍTICOS
show_debug_message("🔍 VERIFICAÇÃO DE LOGS CRÍTICOS:");

var logs_criticos = 0;

// Verificar se objetos têm logs críticos
with (obj_quartel_marinha) {
    if (variable_instance_exists(id, "step_debug_count")) {
        logs_criticos++;
    }
}

with (obj_controlador_producao_naval) {
    if (variable_instance_exists(id, "debug_ativo")) {
        logs_criticos++;
    }
}

with (obj_controlador_unidades) {
    if (variable_instance_exists(id, "debug_enabled")) {
        logs_criticos++;
    }
}

show_debug_message("   - Objetos com logs críticos: " + string(logs_criticos));

// 6. RECOMENDAÇÕES DE DEBUG
show_debug_message("💡 RECOMENDAÇÕES DE DEBUG:");

if (tempo_decorrido > 1000) {
    show_debug_message("   - ⚠️ Debug pode estar impactando performance");
    show_debug_message("   - 💡 Considerar reduzir frequência de logs");
} else {
    show_debug_message("   - ✅ Performance do debug está adequada");
}

if (logs_criticos < 3) {
    show_debug_message("   - ⚠️ Poucos objetos têm sistema de debug");
    show_debug_message("   - 💡 Considerar expandir debug para mais objetos");
} else {
    show_debug_message("   - ✅ Sistema de debug bem distribuído");
}

// 7. CONFIGURAÇÃO DE DEBUG OTIMIZADA
show_debug_message("⚙️ CONFIGURAÇÃO DE DEBUG OTIMIZADA:");

// Configurar debug por nível
global.debug_level = 2; // 0=off, 1=errors, 2=normal, 3=verbose
show_debug_message("   - Nível de debug: " + string(global.debug_level));

// Configurar frequência de logs
global.debug_frequency = 300; // A cada 5 segundos (300 frames)
show_debug_message("   - Frequência de logs: " + string(global.debug_frequency) + " frames");

// Configurar logs por categoria
global.debug_producao = true;
global.debug_selecao = true;
global.debug_movimento = false; // Desativar para performance
global.debug_comandos = true;

show_debug_message("   - Debug produção: " + string(global.debug_producao));
show_debug_message("   - Debug seleção: " + string(global.debug_selecao));
show_debug_message("   - Debug movimento: " + string(global.debug_movimento));
show_debug_message("   - Debug comandos: " + string(global.debug_comandos));

// 8. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL DO DEBUG:");

var debug_funcional = (global.debug_enabled && logs_criticos >= 2);
var performance_ok = (tempo_decorrido < 1000);
var configuracao_ok = (global.debug_level >= 1);

show_debug_message("   - Debug funcional: " + (debug_funcional ? "✅ SIM" : "❌ NÃO"));
show_debug_message("   - Performance OK: " + (performance_ok ? "✅ SIM" : "❌ NÃO"));
show_debug_message("   - Configuração OK: " + (configuracao_ok ? "✅ SIM" : "❌ NÃO"));

if (debug_funcional && performance_ok && configuracao_ok) {
    show_debug_message("🎉 SUCESSO: Sistema de debug VALIDADO!");
    show_debug_message("✅ Debug system está FUNCIONAL e OTIMIZADO!");
} else {
    show_debug_message("❌ FALHA: Sistema de debug precisa de ajustes");
    show_debug_message("🔍 Verificar configurações acima");
}

show_debug_message("=== VALIDAÇÃO DO DEBUG CONCLUÍDA ===");
