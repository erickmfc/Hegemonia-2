// =========================================================
// MINA DE ALUMÍNIO - HERDA DE obj_estrutura_producao
// Configura as propriedades específicas desta estrutura
// =========================================================

// Executar o código do objeto pai primeiro
event_inherited();

// Configurar as propriedades específicas da Mina de Alumínio
producao_por_ciclo = 12;        // Produz 12 unidades de alumínio por ciclo
tipo_recurso = "aluminio";     // Tipo de recurso produzido

show_debug_message("Mina de Alumínio criada - Produção: " + string(producao_por_ciclo) + " alumínio a cada 10 segundos");
