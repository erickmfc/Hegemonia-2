# DIAGNÓSTICO F-5 PRESO NO ESTADO POUSADO

## 🎯 **PROBLEMA IDENTIFICADO**
O F-5 está preso no estado `POUSADO` e não responde ao comando de movimento para decolar e voar.

## 🔧 **CORREÇÕES IMPLEMENTADAS**

### **1. Debug no F-5 (obj_caca_f5/Step_0.gml)**
- ✅ Mensagem de status a cada segundo quando selecionado
- ✅ Debug crítico quando clique direito é detectado
- ✅ Debug de mudança de estado POUSADO -> DECOLANDO

### **2. Correção de Conflito de Input (obj_controlador_unidades/Step_1.gml)**
- ✅ Verificação se unidade já está selecionada
- ✅ Exit do controlador para não interferir
- ✅ Debug para identificar qual objeto processa o clique

---

## 🧪 **TESTE DE DIAGNÓSTICO**

### **Passo 1: Verificar Seleção**
```
1. Execute o jogo
2. Produza um F-5 no Aeroporto Militar
3. Clique ESQUERDO no F-5
4. Verifique se aparece:
   - Círculo verde ao redor do F-5
   - Painel de informações
   - Mensagem: "✈️ F-5 selecionado. Estado atual: POUSADO | Aguardando comando..."
```

### **Passo 2: Testar Comando de Movimento**
```
1. Com o F-5 selecionado, clique DIREITO em qualquer lugar
2. Observe o console e identifique qual cenário acontece:
```

---

## 📊 **CENÁRIOS DE DIAGNÓSTICO**

### **CENÁRIO A: ✅ CLIQUE DIREITO DETECTADO PELO F-5**
**Mensagens esperadas:**
```
!!! CLIQUE DIREITO DETECTADO PELO F-5 !!!
🛫 MUDANÇA DE ESTADO: POUSADO -> DECOLANDO
🎯 Movendo para: (x, y)
```

**Diagnóstico:** ✅ **SUCESSO** - O F-5 está recebendo o comando corretamente.

**Se o F-5 ainda não se move:**
- Verificar se `velocidade_atual` está aumentando
- Verificar se `aceleracao` e `desaceleracao` estão balanceadas
- Verificar se `timer_transicao` está funcionando

### **CENÁRIO B: ❌ CLIQUE DIREITO NÃO DETECTADO**
**Mensagens esperadas:**
```
🎯 CONTROLADOR: Unidade selecionada detectada - deixando comando para a unidade
🎯 CONTROLADOR: Unidade: obj_caca_f5
```

**Diagnóstico:** ✅ **CONFLITO RESOLVIDO** - O controlador está deixando o F-5 processar o comando.

**Se ainda não funciona:**
- Verificar se `global.unidade_selecionada` está sendo definida corretamente
- Verificar se há outros objetos interceptando o input

### **CENÁRIO C: ❌ NENHUMA MENSAGEM**
**Diagnóstico:** ❌ **PROBLEMA CRÍTICO** - O clique direito não está sendo processado por nenhum objeto.

**Possíveis causas:**
- F-5 não está realmente selecionado
- `selecionado = false` no F-5
- Outro objeto está consumindo o input antes

---

## 🔍 **VERIFICAÇÕES ADICIONAIS**

### **1. Verificar Variáveis do F-5**
```gml
// No console, verificar:
show_debug_message("Estado: " + string(estado));
show_debug_message("Selecionado: " + string(selecionado));
show_debug_message("Velocidade: " + string(velocidade_atual));
show_debug_message("Destino: (" + string(destino_x) + ", " + string(destino_y) + ")");
```

### **2. Verificar Lógica de Decolagem**
```gml
// No Step do F-5, verificar se está no case DECOLANDO:
case ESTADO_F5.DECOLANDO:
    altura_voo = min(altura_maxima, altura_voo + 0.5);
    timer_transicao--;
    if (timer_transicao <= 0) {
        estado = ESTADO_F5.MOVENDO;
        show_debug_message("✈️ Decolagem completa!");
    }
    break;
```

### **3. Verificar Função de Movimento**
```gml
// Verificar se mover_aviao() está sendo chamada:
case ESTADO_F5.MOVENDO:
    mover_aviao(); // Esta função deve estar sendo executada
    break;
```

---

## 🎯 **SOLUÇÕES ESPECÍFICAS**

### **Se Cenário A (Clique detectado mas não move):**
```gml
// Ajustar valores no Create do F-5:
aceleracao = 0.1;        // Aumentar aceleração
desaceleracao = 0.05;     // Diminuir desaceleração
velocidade_maxima = 6.0;  // Aumentar velocidade máxima
```

### **Se Cenário B (Conflito resolvido):**
- Sistema funcionando corretamente
- Verificar se F-5 realmente decola após mudança de estado

### **Se Cenário C (Nenhuma mensagem):**
```gml
// Verificar seleção no obj_controlador_unidades/Step_0.gml:
// Linha 117: _instancia_selecionada.selecionado = true;
// Linha 118: global.unidade_selecionada = _instancia_selecionada;
```

---

## 📋 **CHECKLIST DE TESTE**

- [ ] F-5 pode ser selecionado (clique esquerdo)
- [ ] Mensagem de status aparece a cada segundo
- [ ] Clique direito gera mensagem de debug
- [ ] Estado muda de POUSADO para DECOLANDO
- [ ] F-5 começa a se mover
- [ ] Altura de voo aumenta durante decolagem
- [ ] Estado muda para MOVENDO após decolagem
- [ ] F-5 voa para o destino

---

## 🚀 **PRÓXIMOS PASSOS**

1. **Execute o teste** com as mensagens de debug
2. **Identifique o cenário** que acontece
3. **Aplique a solução específica** para o cenário
4. **Verifique se o F-5 decola** corretamente
5. **Teste todos os comandos** (P, O, Q, E, N)

---

**Data:** 2025-01-27  
**Status:** 🔧 **DIAGNÓSTICO IMPLEMENTADO**  
**Próximo:** Executar teste e identificar cenário
