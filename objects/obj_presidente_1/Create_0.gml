// ===============================================
// HEGEMONIA GLOBAL - IA PRESIDENTE 1
// Sistema de Inteligência Artificial para Unidades Inimigas
// ===============================================

// ✅ CORREÇÃO: Garantir que os enums estão disponíveis
// Os enums EstadoAlerta, PlanoEstrategico e FasePlanoDefesa devem estar definidos
// Eles são carregados automaticamente pelos scripts, mas garantimos aqui também
// Nota: No GameMaker, enums definidos em scripts são carregados automaticamente na ordem do projeto

// === IDENTIFICAÇÃO DA IA ===
nacao_proprietaria = 2; // 2 = IA Inimiga
nome_ia = "Presidente 1";

// === SISTEMA DE DECISÃO ===
intervalo_decisao = 60; // REDUZIDO de 90 para 60 - DECISÃO A CADA 1 SEGUNDO (ULTRA RÁPIDA)
timer_decisao = 10; // REDUZIDO de 30 para 10 - COMEÇAR QUASE IMEDIATAMENTE

// === PRIORIDADES DA IA ===
prioridade_economia = 0.2;  // REDUZIDO de 0.4 para 0.2 - MENOS ECONOMIA
prioridade_militar = 0.8;   // AUMENTADO de 0.6 para 0.8 - MAIS AGRESSIVA

// === ESTADO ATUAL ===
objetivo_atual = "expandir"; // expandir, atacar, defender
unidades_totais = 0;
estruturas_totais = 0;

// === POSIÇÃO BASE (onde a IA está posicionada no mapa) ===
// ✅ CORREÇÃO CRÍTICA: Usar posição onde o objeto foi colocado no mapa
// ✅ GARANTIR: O presidente NUNCA se move - sempre fica onde foi colocado
var _posicao_inicial_x = x; // ✅ Guardar posição inicial do mapa
var _posicao_inicial_y = y; // ✅ Guardar posição inicial do mapa
base_x = _posicao_inicial_x; // Posição X do mapa (NUNCA mudar)
base_y = _posicao_inicial_y; // Posição Y do mapa (NUNCA mudar)
raio_expansao = 3000; // AUMENTADO de 800 para 3000 - DETECTA EM TODO O MAPA

// ✅ GARANTIR: O objeto sempre fica na posição onde foi colocado
// NUNCA mover o objeto presidente - ele é um marcador fixo da IA
// ✅ FORÇAR: Garantir que x e y estão na posição correta IMEDIATAMENTE
x = base_x;
y = base_y;

// === UNIDADES EM CONTROLE (cache para performance) ===
lista_unidades = ds_list_create();
lista_estruturas = ds_list_create();
lista_inimigas_visiveis = ds_list_create();

// === COMANDOS MILITARES ===
esquadrao_formando = false;
esquadrao_tamanho_minimo = 2; // REDUZIDO de 5 para 2 - ATACAR COM MENOS UNIDADES
unidades_em_esquadrao = ds_list_create();
alvo_atual = noone;

// === CONTADOR DE ATUALIZAÇÃO ===
counter_update = 0;

// === VISUAL ===
visible = true; // Visível no mapa
image_alpha = 0.7; // ✅ AUMENTADO de 0.3 para 0.7 (mais visível, mas ainda indica que é IA)

// === VERIFICAÇÃO: NÃO PERMITIR NO MAPA2 ===
var _room_name = room_get_name(room);
if (_room_name == "mapa2") {
    show_debug_message("🗑️ obj_presidente_1 detectado no mapa2 - AUTO-DESTRUINDO");
    instance_destroy();
    exit;
}

// === SISTEMA DE DEFESA DO PRESIDENTE ===
// Variáveis de defesa e estado de alerta
// ✅ CORREÇÃO: Script scr_enums_defesa_presidente agora está registrado no projeto
estado_alerta = EstadoAlerta.NORMAL;
ameacas_detectadas = ds_list_create();
unidades_defesa = ds_list_create();
historico_ameacas = ds_map_create();
ultima_verificacao_defesa = 0;
intervalo_verificacao_defesa = 30; // frames

// === DEBUG ===
var _total_instancias = instance_number(object_index);
show_debug_message("🤖 IA " + nome_ia + " inicializada!");
show_debug_message("📍 Posição INICIAL (x, y): (" + string(x) + ", " + string(y) + ")");
show_debug_message("📍 Posição BASE (base_x, base_y): (" + string(base_x) + ", " + string(base_y) + ")");
show_debug_message("📍 ID da instância: " + string(id));
show_debug_message("📍 Room atual: " + _room_name);
show_debug_message("📍 Total de instâncias de obj_presidente_1: " + string(_total_instancias));
if (_total_instancias > 1) {
    show_debug_message("⚠️ AVISO: Existem " + string(_total_instancias) + " instâncias de obj_presidente_1! Deve haver apenas 1!");
    // Listar todas as instâncias
    var _contador = 0;
    with (object_index) {
        show_debug_message("   Instância " + string(_contador) + ": ID=" + string(id) + " | Posição=(" + string(x) + ", " + string(y) + ")");
        _contador++;
    }
}
show_debug_message("💰 Recursos IA: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
show_debug_message("🛡️ Sistema de defesa do presidente inicializado - Estado: NORMAL");

// === SISTEMA DE PLANOS ESTRATÉGICOS ===
// ✅ CORREÇÃO: Script scr_enums_planos_estrategicos já está registrado no projeto
plano_ativo = PlanoEstrategico.NENHUM;
plano_defesa_ativo = false;
fase_plano_defesa = FasePlanoDefesa.DETECCAO;
timer_plano_defesa = 0;

// === SISTEMA DE IDENTIFICAÇÃO TERRITORIAL ===
// ✅ NOVO: Identificar área territorial e costa da IA
tiles_territorio = ds_list_create();
posicoes_costa = ds_list_create();
territorio_identificado = false;

// Identificar território e costa (será feito no Step se o script não estiver disponível)
// ✅ ADIADO: Identificação será feita no Step_0 para garantir que o script está carregado
territorio_identificado = false;