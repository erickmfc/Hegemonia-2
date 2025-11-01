// =========================================================
// HEGEMONIA GLOBAL - QUARTEL
// ✅ DESATIVADO - Sistema antigo não deve ser usado
// O quartel agora usa FILA no Step_0
// =========================================================

// ✅ CORREÇÃO: Este sistema está DESATIVADO - usar apenas fila do Step_0
// Se chegou aqui, é porque o alarme foi ativado incorretamente (herança do pai)
show_debug_message("⚠️ AVISO: Alarm_0 do quartel executado - sistema antigo DESATIVADO");
show_debug_message("⚠️ O quartel deve usar apenas o sistema de FILA no Step_0");

// Desativar alarme e sair
alarm[0] = -1;
exit; // Não executar código antigo
