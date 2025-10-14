// === BR_120: Navio protótipo usando o sistema de classes navais ===

// Classe padrão deste navio
classe = NAVAL_CLASS.CORVETA;

// Aplicar atributos padrão da classe
if (function_exists(naval_apply_defaults)) naval_apply_defaults(id, classe); else global.naval_apply_defaults(id, classe);

// Ajustes específicos do modelo (se quiser diferenciar do default)
// Exemplo: corveta um pouco mais rápida e dano levemente menor
velocidade += 0.2;
dano_ataque = max(1, dano_ataque - 2);

// Estado básico
selecionado = false;
estado = "parado";
destino_x = x; destino_y = y;

// Variáveis de cooldown
_cd = 0;