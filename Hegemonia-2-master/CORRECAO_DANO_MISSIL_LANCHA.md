# 🔧 CORREÇÃO DO DANO DO MÍSSIL DA LANCHA

## ❌ **Problema Identificado**

O míssil da lancha estava sendo desenhado corretamente, mas **não estava causando dano** nos inimigos. O problema estava no sistema de aplicação de dano do `obj_tiro_simples`.

## 🔍 **Causa do Problema**

### **1. Ordem Incorreta de Verificação de Variáveis**
O sistema estava verificando as variáveis de vida na ordem errada:
- ❌ **ANTES**: `hp_atual` → `hp` → `vida`
- ✅ **DEPOIS**: `vida` → `hp_atual` → `hp`

### **2. Barra de Vida Incorreta**
A barra de vida do inimigo estava calculando a porcentagem baseada em 100, mas o inimigo tem 500 de vida inicial:
- ❌ **ANTES**: `perc = vida / 100`
- ✅ **DEPOIS**: `perc = vida / 500`

## ✅ **Correções Implementadas**

### **1. Sistema de Dano Corrigido (`obj_tiro_simples/Step_0.gml`)**
```gml
// ORDEM CORRIGIDA - verificar 'vida' primeiro
if (variable_instance_exists(alvo, "vida")) {
    var _vida_antes = alvo.vida;
    alvo.vida -= dano;
    _dano_aplicado = true;
    show_debug_message("🎯 Dano aplicado na VIDA! Vida: " + string(_vida_antes) + " → " + string(alvo.vida));
} else if (variable_instance_exists(alvo, "hp_atual")) {
    // ... resto do código
}
```

### **2. Verificação de Morte Corrigida**
```gml
// Verificar vida atual na ordem correta
var vida_atual = 0;
if (variable_instance_exists(alvo, "vida")) {
    vida_atual = alvo.vida;
} else if (variable_instance_exists(alvo, "hp_atual")) {
    vida_atual = alvo.hp_atual;
}
```

### **3. Barra de Vida Corrigida (`obj_inimigo/Draw_0.gml` e `Draw_64.gml`)**
```gml
// Calcular porcentagem baseada na vida máxima correta
var vida_maxima = 500; // Vida máxima do inimigo
var perc = max(0, vida) / vida_maxima;
```

### **4. Debug Melhorado**
Adicionado debug detalhado para verificar:
- Quais variáveis de vida existem no alvo
- Se o dano foi aplicado corretamente
- Se o alvo foi destruído

## 🎯 **Resultado Esperado**

Agora o míssil da lancha deve:
1. ✅ **Causar dano visual** na barra de vida do inimigo
2. ✅ **Reduzir a vida** do inimigo de 500 para 470 (dano 30)
3. ✅ **Destruir o inimigo** quando a vida chegar a 0
4. ✅ **Mostrar debug** detalhado no console

## 🧪 **Como Testar**

1. Coloque uma lancha patrulha próxima a um inimigo
2. Aguarde a lancha atirar o míssil
3. Observe:
   - O míssil azul sendo lançado
   - A barra de vida do inimigo diminuindo
   - Mensagens de debug no console
   - O inimigo sendo destruído após vários tiros

## 📊 **Especificações do Dano**

- **Dano por míssil**: 30 pontos
- **Vida do inimigo**: 500 pontos
- **Mísseis necessários para matar**: ~17 mísseis
- **Intervalo entre mísseis**: 2 segundos (120 frames)
