// =========================================================
// HEGEMONIA GLOBAL - PLANTA DE ESTRUTURA DE PRODUÇÃO
// Bloco 2, Fase 2: Lógica de Produção Abstrata (Pai)
// =========================================================
//
// COMO USAR ESTE SISTEMA DE HERANÇA:
//
// 1. Configure o parentObjectId no arquivo .yy do objeto filho:
//    "parentObjectId": {
//      "name": "obj_estrutura_producao",
//      "path": "objects/obj_estrutura_producao/obj_estrutura_producao.yy"
//    }
//
// 2. No Create_0.gml do objeto filho:
//    event_inherited();                    // Executa este código primeiro
//    producao_por_ciclo = 10;             // Define quantidade por ciclo
//    tipo_recurso = "nome_do_recurso";    // Define tipo (ex: "ouro", "cobre")
//
// 3. REMOVA o Alarm_0.gml do objeto filho (ele herdará automaticamente)
//
// RECURSOS SUPORTADOS:
// "dinheiro", "minerio", "petroleo", "populacao", "ouro", "aluminio",
// "cobre", "titanio", "uranio", "litio", "borracha", "silicio", "madeira"
// =========================================================

show_debug_message("Uma estrutura de produção foi criada.");

// Variáveis de instância que os filhos irão definir ('sobrescrever').
// Elas definem a produtividade e o tipo de recurso da estrutura.
producao_por_ciclo = 0; // Quantidade de recurso gerado por ciclo.
tipo_recurso = "";      // O tipo de recurso (ex: "minerio", "petroleo").

// Define o tempo do ciclo de produção em 'game frames'.
// 60 frames = 1 segundo (se o jogo rodar a 60 FPS).
// Um ciclo de 600 frames dura 10 segundos.
var _ciclo_de_producao = 600;

// Ativa o alarme 0 para o primeiro ciclo de produção.
// O alarme é o coração do nosso sistema de geração em tempo real.
alarm[0] = _ciclo_de_producao;