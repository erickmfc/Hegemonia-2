// =========================================================
// MINA DE OURO - HERDA DE obj_estrutura_producao
// Configura as propriedades específicas desta estrutura
// =========================================================

// Executar o código do objeto pai primeiro
event_inherited();

// Configurar as propriedades específicas da Mina de Ouro
producao_por_ciclo = 2;     // Produz 2 unidades de ouro por ciclo
tipo_recurso = "ouro";     // Tipo de recurso produzido

show_debug_message("Mina de Ouro criada - Produção: " + string(producao_por_ciclo) + " ouro a cada 10 segundos");
